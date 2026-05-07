using Microsoft.EntityFrameworkCore;
using TodoApi.Models;

namespace TodoApi.Data
{
    /// <summary>
    /// EF Core DbContext - cầu nối giữa ứng dụng và database SQL Server
    /// Chứa DbSet cho User và Todo, cấu hình relationships
    /// </summary>
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        // DbSet đại diện cho bảng Users trong database
        public DbSet<User> Users { get; set; }

        // DbSet đại diện cho bảng Todos trong database
        public DbSet<Todo> Todos { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // Cấu hình relationship: User 1 - N Todos
            // Khi xóa User thì xóa tất cả Todos của User đó (Cascade Delete)
            modelBuilder.Entity<Todo>()
                .HasOne(t => t.User)
                .WithMany(u => u.Todos)
                .HasForeignKey(t => t.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            // Đảm bảo Email và Username là unique
            modelBuilder.Entity<User>()
                .HasIndex(u => u.Email)
                .IsUnique();

            modelBuilder.Entity<User>()
                .HasIndex(u => u.Username)
                .IsUnique();
        }
    }
}
