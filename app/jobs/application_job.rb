# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError
  queue_as :default

  rescue_from(StandardError) do |exception|
    Sentry.capture_message(exception)
  end

  retry_on StandardError, wait: :exponentially_longer, attempts: 5
end
