# frozen_string_literal: true

class AddressPolicy < ApplicationPolicy
  def index?
    user.present?
  end

  def show?
    admin? || record.user == user
  end

  def create?
    user.present? && (admin? || record.user == user)
  end

  def update?
    admin? || record.user == user
  end

  def destroy?
    admin? || record.user == user
  end

  class Scope < Scope
    def resolve
      return scope.none unless user

      admin? ? scope.all : scope.where(user:)
    end

    private

    def admin?
      user&.admin?
    end
  end

  private

  def admin?
    user&.admin?
  end
end
