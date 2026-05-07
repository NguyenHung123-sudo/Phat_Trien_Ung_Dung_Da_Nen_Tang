using Microsoft.AspNetCore.Mvc;
using TodoApi.Models.DTOs;
using TodoApi.Services;

namespace TodoApi.Controllers
{
    /// <summary>
    /// Controller xử lý Authentication: Register và Login
    /// Không yêu cầu [Authorize] vì user chưa đăng nhập
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;

        public AuthController(AuthService authService)
        {
            _authService = authService;
        }

        /// <summary>
        /// API Đăng ký tài khoản mới
        /// POST: /api/auth/register
        /// </summary>
        [HttpPost("register")]
        public async Task<IActionResult> Register([FromBody] RegisterDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var (success, message, user) = await _authService.RegisterAsync(dto);

            if (!success)
                return BadRequest(new { message });

            return Ok(new { message, userId = user?.Id });
        }

        /// <summary>
        /// API Đăng nhập và nhận JWT Token
        /// POST: /api/auth/login
        /// </summary>
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] LoginDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var (success, message, response) = await _authService.LoginAsync(dto);

            if (!success)
                return Unauthorized(new { message });

            return Ok(response);
        }
    }
}
