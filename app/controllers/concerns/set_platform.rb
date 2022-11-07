# frozen_string_literal: true

module SetPlatform
  extend ActiveSupport::Concern

  included do
    helper_method :platform
  end

  private

  def platform
    @platform ||= ApplicationPlatform.new(request.user_agent)
  end
end
