# frozen_string_literal: true

class AdminPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def dashboard?
    admin_or_staff?
  end

  def reports?
    admin_or_staff?
  end

  private

  def admin_or_staff?
    user&.admin? || user&.staff?
  end
end
