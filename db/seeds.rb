# frozen_string_literal: true

begin
  require 'faker'
rescue LoadError
  module Faker
    module Name
      def self.name
        "User #{SecureRandom.hex(3)}"
      end
    end

    module Internet
      class << self
        def unique
          self
        end

        def email
          "user-#{SecureRandom.hex(4)}@example.com"
        end

        def slug
          SecureRandom.hex(4)
        end

        def url
          'https://example.com'
        end
      end
    end

    module PhoneNumber
      def self.cell_phone
        '0900000000'
      end
    end

    module Commerce
      def self.department(max: 1, fixed_amount: true)
        "Category #{SecureRandom.hex(3)}"
      end

      def self.product_name
        "Product #{SecureRandom.hex(3)}"
      end

      def self.price(range: 10.0..200.0)
        rand(range)
      end
    end

    module Code
      class << self
        def unique
          self
        end

        def asin
          SecureRandom.hex(4)
        end

        def nric
          SecureRandom.hex(4).upcase
        end
      end
    end

    module Company
      def self.name
        "Company #{SecureRandom.hex(3)}"
      end
    end

    module Book
      def self.title
        "Book #{SecureRandom.hex(3)}"
      end
    end

    module Lorem
      def self.sentence(*_args)
        'Lorem ipsum dolor sit amet.'
      end

      def self.paragraph(sentence_count: 5)
        Array.new(sentence_count) { sentence }.join(' ')
      end
    end

    module Address
      def self.street_address
        '123 Demo Street'
      end
    end
  end
end

puts 'Seeding users...'
User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'Admin'
  user.password = 'Password123'
  user.role = :admin
end
20.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: 'Password123',
    phone: "+84#{rand(100000000..999999999)}"
  )
end

puts 'Seeding categories...'
10.times do
  Category.create!(
    name: Faker::Commerce.department(max: 1, fixed_amount: true),
    slug: Faker::Internet.unique.slug,
    description: Faker::Lorem.sentence
  )
end

puts 'Seeding products...'
50.times do
  category = Category.order('RANDOM()').first
  product = Product.create!(
    name: Faker::Commerce.product_name,
    slug: Faker::Internet.unique.slug,
    price: Faker::Commerce.price(range: 10.0..200.0),
    sale_price: Faker::Commerce.price(range: 5.0..150.0),
    description: Faker::Lorem.paragraph(sentence_count: 3),
    stock: rand(10..100),
    category:,
    status: :active,
    weight: rand(0.5..5.0).round(2),
    sku: "SKU-#{SecureRandom.hex(8).upcase}",
    brand: Faker::Company.name
  )
  2.times do
    product.variants.create!(
      option_name: 'Size',
      option_value: %w[S M L XL].sample,
      price: product.price,
      stock: rand(10..50)
    )
  end
  2.times do
    product.product_images.create!(image_url: Faker::Internet.url)
  end
end

puts 'Seeding coupons...'
5.times do
  Coupon.create!(
    code: "COUPON-#{SecureRandom.hex(6).upcase}",
    discount_type: %i[percentage amount].sample,
    discount_value: rand(5..20),
    usage_limit: rand(10..50),
    expired_at: 1.month.from_now
  )
end

puts 'Seeding addresses...'
User.find_each do |user|
  user.addresses.create!(
    name: user.name,
    phone: user.phone || Faker::PhoneNumber.cell_phone,
    province: 'HCM',
    district: 'District 1',
    ward: 'Ward 1',
    street: Faker::Address.street_address,
    default: true
  )
end

puts 'Seeding orders...'
10.times do
  user = User.customer.order('RANDOM()').first
  address = user.addresses.first
  order = user.orders.create!(
    address:,
    status: Order.statuses.keys.sample,
    payment_method: %w[cod vnpay stripe].sample,
    shipping_fee: 2.5,
    total_price: 0
  )
  3.times do
    product = Product.order('RANDOM()').first
    order_item = order.order_items.create!(
      product:,
      quantity: rand(1..3),
      price: product.effective_price
    )
    order.increment!(:total_price, order_item.subtotal)
  end
  order.create_payment!(amount: order.total_price + order.shipping_fee, method: order.payment_method, status: :succeeded, transaction_id: SecureRandom.uuid)
end

puts 'Seeding banners & blog posts...'
5.times do
  Banner.create!(title: Faker::Company.name, image_url: Faker::Internet.url, link_url: Faker::Internet.url)
  BlogPost.create!(title: Faker::Book.title, slug: Faker::Internet.unique.slug, content: Faker::Lorem.paragraph(sentence_count: 10), published: true)
end

puts 'Seed completed.'
