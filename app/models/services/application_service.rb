# frozen_string_literal: true

module Services
  class ApplicationService
    def self.call(*args, &block)
      new(*args, &block).call
    end
  end
end
