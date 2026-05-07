using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using TodoApi.Models.DTOs;
using TodoApi.Services;

namespace TodoApi.Controllers
{
    /// <summary>
    /// Controller xử lý CRUD Todo
    /// [Authorize] - mọi endpoint đều yêu cầu JWT token hợp lệ
    /// UserId được lấy từ Claims trong JWT token (không cần truyền qua body)
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize] // Tất cả endpoints đều cần xác thực JWT
    public class TodosController : ControllerBase
    {
        private readonly TodoService _todoService;

        public TodosController(TodoService todoService)
        {
            _todoService = todoService;
        }

        /// <summary>
        /// Lấy UserId từ JWT token Claims
        /// JWT chứa claim "sub" = UserId được gán lúc tạo token
        /// </summary>
        private int GetCurrentUserId()
        {
            var userIdClaim = User.FindFirst(ClaimTypes.NameIdentifier)?.Value
                           ?? User.FindFirst("sub")?.Value;

            if (string.IsNullOrEmpty(userIdClaim) || !int.TryParse(userIdClaim, out int userId))
                throw new UnauthorizedAccessException("Không xác định được người dùng từ token.");

            return userId;
        }

        /// <summary>
        /// Lấy tất cả todos của user hiện tại
        /// GET: /api/todos
        /// Header: Authorization: Bearer {jwt_token}
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetTodos()
        {
            var userId = GetCurrentUserId();
            var todos = await _todoService.GetTodosByUserIdAsync(userId);
            return Ok(todos);
        }

        /// <summary>
        /// Lấy một todo theo ID
        /// GET: /api/todos/{id}
        /// </summary>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetTodo(int id)
        {
            var userId = GetCurrentUserId();
            var todo = await _todoService.GetTodoByIdAsync(id, userId);

            if (todo == null)
                return NotFound(new { message = "Todo không tìm thấy." });

            return Ok(todo);
        }

        /// <summary>
        /// Tạo todo mới
        /// POST: /api/todos
        /// Body: { "title": "...", "description": "..." }
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> CreateTodo([FromBody] TodoCreateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = GetCurrentUserId();
            var todo = await _todoService.CreateTodoAsync(dto, userId);

            // Trả về 201 Created với URL của resource mới
            return CreatedAtAction(nameof(GetTodo), new { id = todo.Id }, todo);
        }

        /// <summary>
        /// Cập nhật todo
        /// PUT: /api/todos/{id}
        /// Body: { "title": "...", "description": "...", "isCompleted": true/false }
        /// </summary>
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateTodo(int id, [FromBody] TodoUpdateDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var userId = GetCurrentUserId();
            var (success, message, todo) = await _todoService.UpdateTodoAsync(id, dto, userId);

            if (!success)
                return NotFound(new { message });

            return Ok(todo);
        }

        /// <summary>
        /// Xóa todo
        /// DELETE: /api/todos/{id}
        /// </summary>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteTodo(int id)
        {
            var userId = GetCurrentUserId();
            var (success, message) = await _todoService.DeleteTodoAsync(id, userId);

            if (!success)
                return NotFound(new { message });

            return Ok(new { message });
        }
    }
}
