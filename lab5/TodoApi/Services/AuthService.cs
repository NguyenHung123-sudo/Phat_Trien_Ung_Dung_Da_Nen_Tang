using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using TodoApi.Data;
using TodoApi.Models;
using TodoApi.Models.DTOs;

namespace TodoApi.Services
{
    /// <summary>
    /// AuthService xử lý đăng ký, đăng nhập và tạo JWT token
    /// Sử dụng BCrypt để hash password an toàn
    /// </summary>
    public class AuthService
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _configuration;

        public AuthService(AppDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
        }

        /// <summary>
        /// Đăng ký tài khoản mới
        /// - Kiểm tra email đã tồn tại chưa
        /// - Hash password với BCrypt
        /// - Lưu User vào database
        /// </summary>
        public async Task<(bool Success, string Message, User? User)> RegisterAsync(RegisterDto dto)
        {
            // Kiểm tra email đã tồn tại chưa
            var existingUser = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == dto.Email.ToLower());

            if (existingUser != null)
                return (false, "Email đã được sử dụng.", null);

            // Kiểm tra username đã tồn tại chưa
            var existingUsername = await _context.Users
                .FirstOrDefaultAsync(u => u.Username == dto.Username.ToLower());

            if (existingUsername != null)
                return (false, "Username đã được sử dụng.", null);

            // Tạo User mới với password đã hash bởi BCrypt
            var user = new User
            {
                Username = dto.Username.ToLower(),
                Email = dto.Email.ToLower(),
                // BCrypt.HashPassword tự động sinh salt và hash password
                PasswordHash = BCrypt.Net.BCrypt.HashPassword(dto.Password),
                CreatedAt = DateTime.UtcNow
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            return (true, "Đăng ký thành công!", user);
        }

        /// <summary>
        /// Đăng nhập và tạo JWT token
        /// - Tìm user theo email
        /// - Verify password hash
        /// - Tạo JWT token với claims
        /// </summary>
        public async Task<(bool Success, string Message, AuthResponseDto? Response)> LoginAsync(LoginDto dto)
        {
            // Tìm user theo email
            var user = await _context.Users
                .FirstOrDefaultAsync(u => u.Email == dto.Email.ToLower());

            if (user == null)
                return (false, "Email hoặc password không đúng.", null);

            // Verify password với BCrypt.Verify
            if (!BCrypt.Net.BCrypt.Verify(dto.Password, user.PasswordHash))
                return (false, "Email hoặc password không đúng.", null);

            // Tạo JWT token
            var token = GenerateJwtToken(user);
            var expiryHours = int.Parse(_configuration["JwtSettings:ExpiryInHours"] ?? "24");
            var expiresAt = DateTime.UtcNow.AddHours(expiryHours);

            var response = new AuthResponseDto
            {
                Token = token,
                Username = user.Username,
                Email = user.Email,
                UserId = user.Id,
                ExpiresAt = expiresAt,
                Message = "Đăng nhập thành công!"
            };

            return (true, "Đăng nhập thành công!", response);
        }

        /// <summary>
        /// Tạo JWT token chứa các Claims (thông tin user)
        /// Token được ký bằng HMAC-SHA256 với SecretKey
        /// </summary>
        private string GenerateJwtToken(User user)
        {
            var jwtSettings = _configuration.GetSection("JwtSettings");
            var secretKey = jwtSettings["SecretKey"] 
                ?? throw new InvalidOperationException("JWT SecretKey không được cấu hình");
            
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            // Claims là thông tin được nhúng vào JWT token
            // Flutter app sẽ decode token để lấy những thông tin này
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Email, user.Email),
                new Claim(JwtRegisteredClaimNames.UniqueName, user.Username),
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()) // JWT ID - unique identifier
            };

            var expiryHours = int.Parse(jwtSettings["ExpiryInHours"] ?? "24");

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddHours(expiryHours),
                signingCredentials: credentials
            );

            // Serialize token thành chuỗi string dạng: header.payload.signature
            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
