# frozen_string_literal: true

module Api
  module V1
    module Admin
      class DashboardController < Api::V1::BaseController
        def show
          authorize :admin, :dashboard?

          top_products = Product.left_joins(:order_items)
                                 .group('products.id')
                                 .select('products.*, COALESCE(SUM(order_items.quantity), 0) AS sold_units')
                                 .order('sold_units DESC')
                                 .limit(5)

          render_success(
            data: {
              metrics: {
                total_revenue: Order.where(status: %i[paid shipped completed]).sum(:total_price),
                orders_today: Order.where('created_at >= ?', Time.current.beginning_of_day).count,
                customers: User.customer.count
              },
              recent_orders: ActiveModelSerializers::SerializableResource.new(Order.order(created_at: :desc).limit(5), each_serializer: OrderSerializer),
              top_products: top_products.map do |product|
                ProductSerializer.new(product).serializable_hash.merge('sold_units' => product.read_attribute(:sold_units).to_i)
              end
            }
          )
        end
      end
    end
  end
end
