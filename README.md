# Shop API

API thương mại điện tử xây dựng bằng Ruby on Rails 7.2 theo kiến trúc RESTful, hỗ trợ quản trị, khách hàng, thanh toán, khuyến mãi và quản lý đơn hàng.

## 🚀 Tính năng chính
- Đăng ký / đăng nhập / refresh token / quên mật khẩu bằng Devise + JWT
- Quản lý người dùng, phân quyền (customer, staff, admin) với Pundit
- CRUD sản phẩm, danh mục, biến thể, hình ảnh, blog, banner
- Giỏ hàng, đặt hàng, thanh toán (Stripe/VNPay giả lập), khuyến mãi
- Dashboard admin, báo cáo thống kê
- ActiveStorage cho upload, Rack::Attack giới hạn request, Kaminari phân trang
- Serializer JSON chuẩn hóa, Swagger (Rswag) tài liệu API
- RSpec + FactoryBot + Faker cho test mẫu

## 🛠 Yêu cầu hệ thống
- Ruby 3.4.4
- PostgreSQL 14+
- Redis (tùy chọn cho cache/background job)

## 📦 Cài đặt
```bash
git clone <repo>
cd shop-api
bundle install
bin/rails db:create db:migrate db:seed
bin/rails s
```

### Biến môi trường gợi ý
```
POSTGRES_USER=postgres
POSTGRES_PASSWORD=secret
POSTGRES_HOST=localhost
DEVISE_JWT_SECRET_KEY=your-secret
SMTP_ADDRESS=smtp.mailtrap.io
SMTP_USERNAME=xxx
SMTP_PASSWORD=yyy
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=ap-southeast-1
AWS_S3_BUCKET=shop-api-bucket
```

## 🧪 Chạy test
```bash
bundle exec rspec
```

## 📚 Tài liệu Swagger
```bash
bundle exec rswag:specs:swaggerize
```
Swagger UI hiển thị tại: `http://localhost:3000/api/v1/docs`

## 🛠 Lệnh CLI tham khảo
```bash
# Model chính
bin/rails g model User name:string email:string:uniq encrypted_password:string role:integer phone:string
bin/rails g model Category name:string slug:string parent:references
bin/rails g model Product name:string slug:string price:decimal sale_price:decimal description:text stock:integer category:references status:integer weight:decimal sku:string brand:string
bin/rails g model Order user:references address:references total_price:decimal status:integer payment_method:string shipping_fee:decimal
bin/rails g model OrderItem order:references product:references quantity:integer price:decimal
bin/rails g model Payment order:references amount:decimal method:string status:integer transaction_id:string
bin/rails g model Coupon code:string discount_type:integer discount_value:decimal usage_limit:integer used_count:integer expired_at:datetime
bin/rails g model Review user:references product:references rating:integer comment:text

# Controller / Serializer / Policy
bin/rails g controller api/v1/products
bin/rails g serializer product
bin/rails g pundit:policy product
```

## 📮 Ví dụ cURL
```bash
# Đăng ký
curl -X POST http://localhost:3000/api/v1/auth/sign_up \
  -H 'Content-Type: application/json' \
  -d '{"user":{"name":"John","email":"john@example.com","password":"Password123","password_confirmation":"Password123"}}'

# Đăng nhập
curl -X POST http://localhost:3000/api/v1/auth/sign_in \
  -H 'Content-Type: application/json' \
  -d '{"email":"john@example.com","password":"Password123"}'

# Danh sách sản phẩm
curl http://localhost:3000/api/v1/products
```

## 🧭 Lộ trình mở rộng
- Thanh toán đa kênh thực tế (Momo, ZaloPay, PayPal)
- Loyalty/Referral, chương trình điểm thưởng
- Wishlist, so sánh sản phẩm, gợi ý AI
- Đa ngôn ngữ, đa cửa hàng, marketplace
- Tích hợp CRM, Marketing Automation, Affiliate tracking

## 📄 Giấy phép
MIT License
