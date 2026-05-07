using System.ComponentModel.DataAnnotations;

namespace TodoApi.Models
{
    /// <summary>
    /// Entity đại diện cho người dùng trong hệ thống
    /// </summary>
    public class User
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(50)]
        public string Username { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string Email { get; set; } = string.Empty;

        [Required]
        public string PasswordHash { get; set; } = string.Empty;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Navigation property - một User có nhiều Todos
        public ICollection<Todo> Todos { get; set; } = new List<Todo>();
    }
}
