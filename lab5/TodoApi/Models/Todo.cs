using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TodoApi.Models
{
    /// <summary>
    /// Entity đại diện cho một Todo item
    /// </summary>
    public class Todo
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [MaxLength(200)]
        public string Title { get; set; } = string.Empty;

        [MaxLength(1000)]
        public string? Description { get; set; }

        public bool IsCompleted { get; set; } = false;

        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        public DateTime? UpdatedAt { get; set; }

        // Foreign key - Todo thuộc về một User
        [ForeignKey("User")]
        public int UserId { get; set; }

        // Navigation property
        public User? User { get; set; }
    }
}
