# Lab 5 - Flutter Todo App với ASP.NET Core JWT Backend

## 📁 Cấu trúc Project

```
d:\Lab5\
├── TodoApi\                        ← ASP.NET Core Web API Backend
│   ├── Controllers\
│   │   ├── AuthController.cs       # POST /api/auth/register, /api/auth/login
│   │   └── TodosController.cs      # CRUD /api/todos (Authorize)
│   ├── Models\
│   │   ├── User.cs                 # Entity User (Id, Username, Email, PasswordHash)
│   │   ├── Todo.cs                 # Entity Todo (Id, Title, Description, IsCompleted, UserId)
│   │   └── DTOs\
│   │       ├── AuthDtos.cs         # RegisterDto, LoginDto, AuthResponseDto
│   │       └── TodoDtos.cs         # TodoCreateDto, TodoUpdateDto, TodoResponseDto
│   ├── Data\
│   │   └── AppDbContext.cs         # EF Core DbContext → SQL Server
│   ├── Services\
│   │   ├── AuthService.cs          # JWT generation + BCrypt password hash
│   │   └── TodoService.cs          # CRUD business logic
│   ├── Migrations\                 # EF Core auto-generated migrations
│   ├── appsettings.json            # JWT config + Connection String
│   └── Program.cs                  # Middleware, DI, CORS, Swagger, Auto-migrate
│
└── flutter_todo_app\               ← Flutter Frontend
    ├── lib\
    │   ├── main.dart               # Entry point, routing, theme
    │   ├── config\
    │   │   └── api_config.dart     # Base URL + API endpoints
    │   ├── models\
    │   │   ├── todo_model.dart     # TodoModel ↔ TodoResponseDto
    │   │   └── user_model.dart     # UserModel ↔ AuthResponseDto
    │   ├── services\
    │   │   ├── auth_service.dart   # Login/Register/Logout + SharedPreferences
    │   │   └── todo_service.dart   # CRUD + Bearer token injection
    │   ├── screens\
    │   │   ├── splash_screen.dart  # JWT check → redirect
    │   │   ├── login_screen.dart   # Đăng nhập
    │   │   ├── register_screen.dart# Đăng ký
    │   │   └── dashboard_screen.dart # Todo list + CRUD
    │   └── widgets\
    │       ├── todo_card.dart      # Todo item với toggle/edit/delete
    │       └── add_todo_dialog.dart# Dialog thêm/sửa todo
    └── pubspec.yaml
```

---

## 🚀 Hướng Dẫn Chạy

### Bước 1: Chạy Backend (ASP.NET Core)

```powershell
cd d:\Lab5\TodoApi
dotnet run --launch-profile http
```

> ✅ Backend chạy tại: **http://localhost:5001**  
> ✅ Swagger UI: **http://localhost:5001** (tự mở)  
> ✅ Database tự động tạo khi khởi động lần đầu

**API Endpoints:**

| Method | Endpoint | Auth | Mô tả |
|--------|----------|------|-------|
| POST | `/api/auth/register` | ❌ | Đăng ký tài khoản |
| POST | `/api/auth/login` | ❌ | Đăng nhập, nhận JWT |
| GET | `/api/todos` | ✅ Bearer | Lấy tất cả todos |
| POST | `/api/todos` | ✅ Bearer | Tạo todo mới |
| PUT | `/api/todos/{id}` | ✅ Bearer | Cập nhật todo |
| DELETE | `/api/todos/{id}` | ✅ Bearer | Xóa todo |

---

### Bước 2: Cấu Hình Flutter App

Mở file `flutter_todo_app\lib\config\api_config.dart`:

```dart
// Chạy trên Web / Windows → giữ nguyên localhost
static const String _baseHost = 'localhost';

// Chạy trên Android Emulator → đổi thành:
static const String _baseHost = '10.0.2.2';

// Chạy trên thiết bị thật → đổi thành IP WiFi máy tính:
static const String _baseHost = '192.168.1.xxx';
```

### Bước 3: Chạy Flutter App

```powershell
cd d:\Lab5\flutter_todo_app

# Chạy trên Chrome (Web)
flutter run -d chrome

# Chạy trên Windows Desktop
flutter run -d windows

# Chạy trên Android Emulator (cần đổi IP trong api_config.dart)
flutter run -d emulator-xxxx
```

---

## 🔐 Luồng JWT Authentication

```
1. Register  →  POST /api/auth/register  →  Tạo user, hash password BCrypt
2. Login     →  POST /api/auth/login     →  Verify BCrypt, tạo JWT token (24h)
3. App       →  Lưu JWT vào SharedPreferences
4. Request   →  Header: "Authorization: Bearer <token>"
5. Backend   →  Validate token (Issuer, Audience, Signature, Expiry)
6. Extract   →  ClaimTypes.NameIdentifier = UserId
7. Todos     →  WHERE UserId = currentUser (bảo mật data isolation)
```

---

## 🧩 JWT Token Structure

```
Header:  { "alg": "HS256", "typ": "JWT" }
Payload: {
  "sub": "1",                    ← UserId
  "email": "user@example.com",
  "unique_name": "username",
  "nameid": "1",
  "jti": "uuid",                 ← JWT ID (unique)
  "exp": 1234567890              ← Expiry timestamp
}
Signature: HMAC-SHA256(header + payload, SecretKey)
```

---

## 🛠️ Công Nghệ Sử Dụng

### Backend
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| Microsoft.EntityFrameworkCore.SqlServer | 8.0.0 | ORM SQL Server |
| Microsoft.AspNetCore.Authentication.JwtBearer | 8.0.0 | JWT Middleware |
| BCrypt.Net-Next | 4.0.3 | Password hashing |
| Swashbuckle.AspNetCore | 6.5.0 | Swagger UI |

### Flutter
| Package | Phiên bản | Mục đích |
|---------|-----------|----------|
| http | ^1.2.0 | HTTP requests |
| shared_preferences | ^2.2.2 | Lưu JWT token |
| jwt_decoder | ^2.0.1 | Decode JWT, check expiry |
| provider | ^6.1.1 | State management |
| google_fonts | ^6.1.0 | Typography |

---

## ⚠️ Lưu Ý Quan Trọng

1. **SQL Server LocalDB** phải được cài (đi kèm Visual Studio)
2. Backend **phải chạy trước** Flutter app
3. **CORS** đã được cấu hình `AllowAnyOrigin` trong Development
4. JWT token có hiệu lực **24 giờ** (cấu hình trong `appsettings.json`)
5. Khi chạy trên **Android Emulator**: đổi `_baseHost` thành `10.0.2.2`
