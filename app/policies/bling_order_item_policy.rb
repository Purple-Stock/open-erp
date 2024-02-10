class BlingOrderItemPolicy < ApplicationPolicy
  def index?
    @account = user.account
    @enabled ||= @account.account_features.includes([:feature])
                        .select { |account_feature| account_feature.feature.bling_integration? }&.first&.is_enabled?
  end

  def others_status?
    index?
  end
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
