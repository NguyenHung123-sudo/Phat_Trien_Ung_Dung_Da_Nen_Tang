using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using TodoApi.Data;
using TodoApi.Services;

var builder = WebApplication.CreateBuilder(args);

// ─────────────────────────────────────────────────
// 1. DATABASE - Entity Framework Core với SQL Server
// ─────────────────────────────────────────────────
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        sqlOptions => sqlOptions.EnableRetryOnFailure(
            maxRetryCount: 5,
            maxRetryDelay: TimeSpan.FromSeconds(30),
            errorNumbersToAdd: null)
    )
);

// ─────────────────────────────────────────────────
// 2. DEPENDENCY INJECTION - Đăng ký Services
// ─────────────────────────────────────────────────
builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<TodoService>();

// ─────────────────────────────────────────────────
// 3. JWT AUTHENTICATION
// ─────────────────────────────────────────────────
var jwtSettings = builder.Configuration.GetSection("JwtSettings");
var secretKey = jwtSettings["SecretKey"]
    ?? throw new InvalidOperationException("JWT SecretKey chưa được cấu hình trong appsettings.json");

builder.Services.AddAuthentication(options =>
{
    // Đặt scheme mặc định là JWT Bearer
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,            // Kiểm tra Issuer khớp không
        ValidateAudience = true,          // Kiểm tra Audience khớp không
        ValidateLifetime = true,          // Kiểm tra token còn hạn không
        ValidateIssuerSigningKey = true,  // Kiểm tra chữ ký hợp lệ không
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secretKey)),
        ClockSkew = TimeSpan.Zero         // Không cho phép độ trễ thời gian
    };

    // Trả về message rõ ràng khi token không hợp lệ
    options.Events = new JwtBearerEvents
    {
        OnAuthenticationFailed = context =>
        {
            if (context.Exception.GetType() == typeof(SecurityTokenExpiredException))
                context.Response.Headers.Append("Token-Expired", "true");
            return Task.CompletedTask;
        }
    };
});

builder.Services.AddAuthorization();

// ─────────────────────────────────────────────────
// 4. CORS - Cho phép Flutter app gọi API
// ─────────────────────────────────────────────────
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFlutter", policy =>
    {
        policy
            .AllowAnyOrigin()   // Cho phép mọi origin (thay đổi nếu production)
            .AllowAnyMethod()   // GET, POST, PUT, DELETE, etc.
            .AllowAnyHeader();  // Authorization, Content-Type, etc.
    });
});

// ─────────────────────────────────────────────────
// 5. SWAGGER - API Documentation
// ─────────────────────────────────────────────────
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "Todo API",
        Version = "v1",
        Description = "ASP.NET Core Web API với JWT Authentication cho Flutter Todo App"
    });

    // Thêm nút Authorize vào Swagger UI để test với JWT token
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "Nhập: Bearer {your_jwt_token}"
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// ─────────────────────────────────────────────────
// BUILD APP
// ─────────────────────────────────────────────────
var app = builder.Build();

// ─────────────────────────────────────────────────
// 6. AUTO MIGRATE DATABASE khi khởi động
// ─────────────────────────────────────────────────
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    try
    {
        // Kiểm tra xem có pending migrations không trước khi chạy
        var pendingMigrations = db.Database.GetPendingMigrations().ToList();
        if (pendingMigrations.Count > 0)
        {
            db.Database.Migrate();
            Console.WriteLine("✅ Database migration thành công!");
        }
        else
        {
            Console.WriteLine("✅ Database đã up-to-date, không cần migration.");
        }
    }
    catch (Exception ex)
    {
        // Nếu lỗi do bảng đã tồn tại → database OK, bỏ qua
        if (ex.Message.Contains("already an object named") || 
            ex.Message.Contains("already exists"))
        {
            Console.WriteLine("⚠️ Database tables đã tồn tại - tiếp tục khởi động.");
        }
        else
        {
            Console.WriteLine($"❌ Lỗi migration: {ex.Message}");
        }
    }
}

// ─────────────────────────────────────────────────
// 7. MIDDLEWARE PIPELINE
// ─────────────────────────────────────────────────
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Todo API v1");
        c.RoutePrefix = string.Empty; // Swagger ở root URL: https://localhost:7001/
    });
}

app.UseCors("AllowFlutter");        // CORS phải trước Authentication
app.UseAuthentication();             // Xử lý JWT token
app.UseAuthorization();              // Kiểm tra quyền truy cập
app.MapControllers();

app.Run();
