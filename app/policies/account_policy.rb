# frozen_string_literal: true

class AccountPolicy
  attr_reader :account

  def initialize(account)
    @account = account
  end

  def enabled?
    bling_feature = account.account_features.includes([:account_features]).select { |account_feature| account_feature.feature.bling_integration? }
    bling_feature&.first&.is_enabled?
  end
end
