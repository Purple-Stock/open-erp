# frozen_string_literal: true

# To call ErrorDecorator.new(model.errors).full_messages inside an invalid request action
class ErrorDecorator < Draper::Decorator
  delegate_all

  def full_messages
    object.full_messages.join(', ')
  end
end
