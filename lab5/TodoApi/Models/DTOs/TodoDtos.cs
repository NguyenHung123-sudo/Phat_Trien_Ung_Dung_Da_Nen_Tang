using System.ComponentModel.DataAnnotations;

namespace TodoApi.Models.DTOs
{
    /// <summary>
    /// DTO dùng khi tạo hoặc cập nhật Todo
    /// </summary>
    public class TodoCreateDto
    {
        [Required(ErrorMessage = "Title là bắt buộc")]
        [MaxLength(200, ErrorMessage = "Title không quá 200 ký tự")]
        public string Title { get; set; } = string.Empty;

        [MaxLength(1000, ErrorMessage = "Description không quá 1000 ký tự")]
        public string? Description { get; set; }
    }

    /// <summary>
    /// DTO dùng khi cập nhật Todo (bao gồm cả trạng thái hoàn thành)
    /// </summary>
    public class TodoUpdateDto
    {
        [Required(ErrorMessage = "Title là bắt buộc")]
        [MaxLength(200, ErrorMessage = "Title không quá 200 ký tự")]
        public string Title { get; set; } = string.Empty;

        [MaxLength(1000, ErrorMessage = "Description không quá 1000 ký tự")]
        public string? Description { get; set; }

        public bool IsCompleted { get; set; }
    }

    /// <summary>
    /// DTO trả về thông tin Todo cho client
    /// </summary>
    public class TodoResponseDto
    {
        public int Id { get; set; }
        public string Title { get; set; } = string.Empty;
        public string? Description { get; set; }
        public bool IsCompleted { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime? UpdatedAt { get; set; }
        public int UserId { get; set; }
    }
}
