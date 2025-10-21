# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  def index?
    admin_or_staff? || user.present?
  end

  def show?
    return true if record.is_a?(Class)

    admin_or_staff? || record.user_id == user&.id
  end

  def create?
    user.present?
  end

  def update?
    return admin_or_staff? if record.is_a?(Class)

    admin_or_staff? || record.user_id == user&.id
  end

  def cancel?
    update?
  end

  def complete?
    admin_or_staff?
  end

  def ship?
    admin_or_staff?
  end

  class Scope < Scope
    def resolve
      return scope.all if admin_or_staff?

      scope.where(user_id: user.id)
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
