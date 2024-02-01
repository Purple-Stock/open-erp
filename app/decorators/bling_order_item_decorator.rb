# frozen_string_literal: true

# Decorator Pattern applied, check https://github.com/drapergem/draper
class BlingOrderItemDecorator < Draper::Decorator
  include AbstractController::Translation
  delegate :situation_id_humanize, :store_id_humanize

  def title
    "#{t('activerecord.attributes.bling_order_items.bling_order_id')} #{model.bling_order_id}"
  end

  def situation_id
    situation_id_humanize
  end

  def store_id
    store_id_humanize
  end

  def created_at
    localize(model.created_at, format: :default)
  end

  def updated_at
    localize(model.updated_at, format: :default)
  end

  def date
    localize(model.date, format: :short)
  end

  def alteration_date
    return if model.alteration_date.blank?

    localize(model.alteration_date, format: :short)
  end
end
