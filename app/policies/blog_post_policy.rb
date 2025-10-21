# frozen_string_literal: true

class BlogPostPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || admin_or_staff?
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
      if admin_or_staff?
        scope.all
      else
        scope.published
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
