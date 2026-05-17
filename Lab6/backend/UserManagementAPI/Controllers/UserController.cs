using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using UserManagementAPI.Models;

namespace UserManagementAPI.Controllers
{
    [ApiController]
    [Route("api/user")]
    [Authorize]
    public class UserController : ControllerBase
    {
        private readonly UserManager<ApplicationUser> _userManager;

        public UserController(UserManager<ApplicationUser> userManager)
        {
            _userManager = userManager;
        }

        // GET /api/user/all  — Admin only
        [HttpGet("all")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> GetAllUsers()
        {
            var users = _userManager.Users.ToList();
            var result = new List<object>();

            foreach (var user in users)
            {
                var roles = await _userManager.GetRolesAsync(user);
                result.Add(new
                {
                    id = user.Id,
                    email = user.Email,
                    fullName = user.FullName,
                    role = roles.FirstOrDefault() ?? "N/A",
                    createdAt = user.CreatedAt
                });
            }

            return Ok(result);
        }

        // DELETE /api/user/{id}  — Admin only
        [HttpDelete("{id}")]
        [Authorize(Roles = "Admin")]
        public async Task<IActionResult> DeleteUser(string id)
        {
            var user = await _userManager.FindByIdAsync(id);
            if (user == null)
                return NotFound(new { message = "User not found." });

            // Prevent self-deletion
            var currentUserId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (user.Id == currentUserId)
                return BadRequest(new { message = "You cannot delete your own account." });

            var result = await _userManager.DeleteAsync(user);
            if (!result.Succeeded)
                return StatusCode(500, new { message = "Failed to delete user." });

            return Ok(new { message = $"User {user.Email} deleted successfully." });
        }

        // GET /api/user/me  — Any authenticated user
        [HttpGet("me")]
        public async Task<IActionResult> GetCurrentUser()
        {
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;
            if (userId == null) return Unauthorized();

            var user = await _userManager.FindByIdAsync(userId);
            if (user == null) return NotFound();

            var roles = await _userManager.GetRolesAsync(user);
            return Ok(new
            {
                id = user.Id,
                email = user.Email,
                fullName = user.FullName,
                role = roles.FirstOrDefault() ?? "N/A",
                createdAt = user.CreatedAt
            });
        }
    }
}
