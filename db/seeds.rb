require 'faker'

35.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "foobar"
  password_confirmation = "foobar"
  phone = Faker::PhoneNumber.cell_phone
  address = Faker::Address.street_address
  User.create!(name: name, phone: phone, address: address,
    password: password, password_confirmation: password_confirmation, email: email, activated: 1)
end

men = Category.create!(name: "Men")
woman = Category.create!(name: "Woman")

m_shirt = men.categories.create!(name: "Shirt")
w_shirt = woman.categories.create!(name: "Shirt")

m_shirt.categories.create!(name: "Sporty")
w_shirt.categories.create!(name: "Casuals")

m_pants = men.categories.create!(name: "Pants")
w_pants = woman.categories.create!(name: "Pants")

m_pants.categories.create!(name: "Jeans")
w_pants.categories.create!(name: "Legging")

woman.categories.create!(name: "Dress")

categories = Category.where("id > ?", 2)

quantity_in_stock = 50
count = 1
categories.each do |category|
  5.times do
    name = "Product" + "-" + count.to_s
    product = category.products.create!(name: name, price: 50, quantity_in_stock: quantity_in_stock)
    product_image = product.product_images.create!
    product_image.image.attach(io: File.open("app/assets/images/ProductImage/product#{rand(1..5)}.jpg"), filename: "product#{rand(1..35)}.jpg")
  count += 1
  end
end

users = User.all

users.each do |user|
  rand(6..12).times do
    status = rand(0..4)
    user.orders.create!(status: status)
  end
end

orders = Order.all
orders.each do |order|
  arr = (1..25).to_a
  rand(3..6).times do
    product_id = arr.sample
    quantity = rand(1..3)
    od = order.order_details.new(product_id: product_id, quantity: quantity)
    od.save!
    price = od.product.price
    od.update(price: price)
    arr.delete(product_id)
  end
  amount = 0
  order.order_details.each do |od|
    amount += od.price * od.quantity
  end
  order.update(amount: amount)
end
