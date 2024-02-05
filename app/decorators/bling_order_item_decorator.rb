# frozen_string_literal: true

# Decorator Pattern applied, check https://github.com/drapergem/draper
class BlingOrderItemDecorator < Draper::Decorator
  include AbstractController::Translation
  include ActionView::Helpers::NumberHelper
  delegate_all

  def title
    "#{t('activerecord.attributes.bling_order_item.bling_order_id')} #{model.bling_order_id}"
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

  def value
    number_to_currency model.value
  end

  def situations_for_select
    paired_array = BlingOrderItemStatus.to_a
    paired_array.slice!(0)
    paired_array
  end

  def class_name
    t('activerecord.models.bling_order_items.one')
  end
end
