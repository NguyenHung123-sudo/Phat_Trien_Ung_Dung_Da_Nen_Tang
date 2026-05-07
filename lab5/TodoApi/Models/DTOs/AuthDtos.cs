using System.ComponentModel.DataAnnotations;

namespace TodoApi.Models.DTOs
{
    /// <summary>
    /// DTO dùng khi đăng ký tài khoản mới
    /// </summary>
    public class RegisterDto
    {
        [Required(ErrorMessage = "Username là bắt buộc")]
        [MinLength(3, ErrorMessage = "Username phải có ít nhất 3 ký tự")]
        [MaxLength(50, ErrorMessage = "Username không quá 50 ký tự")]
        public string Username { get; set; } = string.Empty;

        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password là bắt buộc")]
        [MinLength(6, ErrorMessage = "Password phải có ít nhất 6 ký tự")]
        public string Password { get; set; } = string.Empty;
    }

    /// <summary>
    /// DTO dùng khi đăng nhập
    /// </summary>
    public class LoginDto
    {
        [Required(ErrorMessage = "Email là bắt buộc")]
        [EmailAddress(ErrorMessage = "Email không hợp lệ")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Password là bắt buộc")]
        public string Password { get; set; } = string.Empty;
    }

    /// <summary>
    /// DTO trả về khi đăng nhập thành công, chứa JWT token
    /// </summary>
    public class AuthResponseDto
    {
        public string Token { get; set; } = string.Empty;
        public string Username { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public int UserId { get; set; }
        public DateTime ExpiresAt { get; set; }
        public string Message { get; set; } = string.Empty;
    }
}
