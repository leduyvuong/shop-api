# frozen_string_literal: true

class PaymentPolicy < ApplicationPolicy
  def index?
    if record.is_a?(Class)
      admin_or_staff? || user.present?
    else
      admin_or_staff? || record.order.user_id == user&.id
    end
  end

  def show?
    admin_or_staff? || record.order.user_id == user&.id
  end

  def create?
    admin_or_staff? || record.order.user_id == user&.id
  end

  class Scope < Scope
    def resolve
      if admin_or_staff?
        scope.all
      else
        scope.joins(:order).where(orders: { user_id: user.id })
      end
    end

    private

    def admin_or_staff?
      user&.admin? || user&.staff?
    end
  end

  private

  def admin_or_staff?
    user&.admin? || user&.staff?
  end
end
