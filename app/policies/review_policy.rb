# frozen_string_literal: true

class ReviewPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    record.user_id == user&.id
  end

  def destroy?
    admin_or_owner?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def admin_or_owner?
    user&.admin? || record.user_id == user&.id
  end
end
