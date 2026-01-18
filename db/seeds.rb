# Admin User
User.create!(
  email_address: "admin@terral.com",
  password: "password123",
  password_confirmation: "password123"
)

puts "✅ Admin user created: admin@terral.com / password123"
