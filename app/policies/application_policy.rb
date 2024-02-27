# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    bling_feature_flag?
  end

  def show?
    false
  end

  def create?
    bling_feature_flag?
  end

  def new?
    bling_feature_flag?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  private

  def bling_feature_flag?
    @account = user.account
    @enabled ||= @account.account_features.includes([:feature])
                         .select { |account_feature| account_feature.feature.bling_integration? }&.first&.is_enabled?
  end

  class Scope
    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      raise NotImplementedError, "You must define #resolve in #{self.class}"
    end

    private

    attr_reader :user, :scope
  end
end
