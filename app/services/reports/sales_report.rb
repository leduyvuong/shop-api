# frozen_string_literal: true

module Reports
  class SalesReport
    RANGE_MAP = {
      'daily' => 1.day,
      'weekly' => 1.week,
      'monthly' => 1.month
    }.freeze

    def initialize(range: 'daily')
      @range_key = RANGE_MAP.key?(range) ? range : 'daily'
      @range = RANGE_MAP.fetch(@range_key)
    end

    def call
      orders = Order.where('created_at >= ?', Time.current - range)
      revenue = orders.sum(:total_price)
      breakdown = orders.group("DATE_TRUNC('day', created_at)").sum(:total_price)

      {
        range: range_key,
        total_orders: orders.count,
        revenue:,
        breakdown: breakdown.transform_keys { |date| date.to_date }
      }
    end

    private

    attr_reader :range, :range_key
  end
end
