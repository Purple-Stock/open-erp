# frozen_string_literal: true

# Decorator Pattern applied, check https://github.com/drapergem/draper
class BlingOrderItemDecorator < Draper::Decorator
  include AbstractController::Translation

  def title
    "#{t('activerecord.attributes.bling_order_items.bling_order_id')} #{model.bling_order_id}"
  end
end
