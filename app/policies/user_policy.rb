# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || record == user
  end

  def create?
    admin?
  end

  def update?
    admin? || record == user
  end

  def destroy?
    admin?
  end

  class Scope < Scope
    def resolve
      admin? ? scope.all : scope.where(id: user.id)
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
