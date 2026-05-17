using System.ComponentModel.DataAnnotations;

namespace UserManagementAPI.Models
{
    public class RegisterModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; } = string.Empty;

        [Required]
        [MinLength(6)]
        public string Password { get; set; } = string.Empty;

        /// <summary>Admin, Customer, or Vendor</summary>
        [Required]
        public string Role { get; set; } = "Customer";

        public string? FullName { get; set; }
    }
}
