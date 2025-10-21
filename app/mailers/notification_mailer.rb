# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  def order_created
    @order = params[:order]
    mail to: @order.user.email, subject: 'Đơn hàng của bạn đã được tạo'
  end

  def order_canceled
    @order = params[:order]
    mail to: @order.user.email, subject: 'Đơn hàng của bạn đã bị hủy'
  end
end
