# frozen_string_literal: true

class BannerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    admin_or_staff?
  end

  def update?
    admin_or_staff?
  end

  def destroy?
    admin_or_staff?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def admin_or_staff?
    user&.admin? || user&.staff?
  end
end
