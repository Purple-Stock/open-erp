# frozen_string_literal: true

class AccountPolicy
  attr_reader :account, :enabled

  def initialize(account)
    @account = account
    @enabled ||= account.account_features.includes([:feature])
                        .select { |account_feature| account_feature.feature.bling_integration? }&.first&.is_enabled?
  end
end
