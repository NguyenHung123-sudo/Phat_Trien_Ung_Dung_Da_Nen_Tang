using Microsoft.EntityFrameworkCore;
using TodoApi.Data;
using TodoApi.Models;
using TodoApi.Models.DTOs;

namespace TodoApi.Services
{
    /// <summary>
    /// TodoService chứa business logic cho CRUD operations
    /// Đảm bảo mỗi user chỉ truy cập được todos của mình
    /// </summary>
    public class TodoService
    {
        private readonly AppDbContext _context;

        public TodoService(AppDbContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Lấy tất cả todos của một user cụ thể
        /// Sắp xếp theo thời gian tạo giảm dần (mới nhất lên đầu)
        /// </summary>
        public async Task<List<TodoResponseDto>> GetTodosByUserIdAsync(int userId)
        {
            return await _context.Todos
                .Where(t => t.UserId == userId)
                .OrderByDescending(t => t.CreatedAt)
                .Select(t => new TodoResponseDto
                {
                    Id = t.Id,
                    Title = t.Title,
                    Description = t.Description,
                    IsCompleted = t.IsCompleted,
                    CreatedAt = t.CreatedAt,
                    UpdatedAt = t.UpdatedAt,
                    UserId = t.UserId
                })
                .ToListAsync();
        }

        /// <summary>
        /// Lấy một todo theo ID, kiểm tra userId để đảm bảo bảo mật
        /// </summary>
        public async Task<TodoResponseDto?> GetTodoByIdAsync(int id, int userId)
        {
            var todo = await _context.Todos
                .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

            if (todo == null) return null;

            return new TodoResponseDto
            {
                Id = todo.Id,
                Title = todo.Title,
                Description = todo.Description,
                IsCompleted = todo.IsCompleted,
                CreatedAt = todo.CreatedAt,
                UpdatedAt = todo.UpdatedAt,
                UserId = todo.UserId
            };
        }

        /// <summary>
        /// Tạo todo mới cho user
        /// </summary>
        public async Task<TodoResponseDto> CreateTodoAsync(TodoCreateDto dto, int userId)
        {
            var todo = new Todo
            {
                Title = dto.Title,
                Description = dto.Description,
                IsCompleted = false,
                CreatedAt = DateTime.UtcNow,
                UserId = userId
            };

            _context.Todos.Add(todo);
            await _context.SaveChangesAsync();

            return new TodoResponseDto
            {
                Id = todo.Id,
                Title = todo.Title,
                Description = todo.Description,
                IsCompleted = todo.IsCompleted,
                CreatedAt = todo.CreatedAt,
                UpdatedAt = todo.UpdatedAt,
                UserId = todo.UserId
            };
        }

        /// <summary>
        /// Cập nhật todo - kiểm tra todo thuộc về user trước khi update
        /// </summary>
        public async Task<(bool Success, string Message, TodoResponseDto? Todo)> UpdateTodoAsync(
            int id, TodoUpdateDto dto, int userId)
        {
            var todo = await _context.Todos
                .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

            if (todo == null)
                return (false, "Todo không tồn tại hoặc bạn không có quyền sửa.", null);

            todo.Title = dto.Title;
            todo.Description = dto.Description;
            todo.IsCompleted = dto.IsCompleted;
            todo.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return (true, "Cập nhật thành công!", new TodoResponseDto
            {
                Id = todo.Id,
                Title = todo.Title,
                Description = todo.Description,
                IsCompleted = todo.IsCompleted,
                CreatedAt = todo.CreatedAt,
                UpdatedAt = todo.UpdatedAt,
                UserId = todo.UserId
            });
        }

        /// <summary>
        /// Xóa todo - kiểm tra todo thuộc về user trước khi xóa
        /// </summary>
        public async Task<(bool Success, string Message)> DeleteTodoAsync(int id, int userId)
        {
            var todo = await _context.Todos
                .FirstOrDefaultAsync(t => t.Id == id && t.UserId == userId);

            if (todo == null)
                return (false, "Todo không tồn tại hoặc bạn không có quyền xóa.");

            _context.Todos.Remove(todo);
            await _context.SaveChangesAsync();

            return (true, "Xóa todo thành công!");
        }
    }
}
