# frozen_string_literal: true

# Decorator Pattern applied, check https://github.com/drapergem/draper
class ProductDecorator < Draper::Decorator
  include AbstractController::Translation
  include ActionView::Helpers::NumberHelper
  delegate_all

  LIMIT_TO_TRUNCATE_SKU = 17

  def human_attribute(attribute_key)
    model.class.human_attribute_name(attribute_key)
  end

  def sku
    return model.sku if model.sku.blank? || model.sku.length < LIMIT_TO_TRUNCATE_SKU

    "#{model.sku.split('')[0..15].join('')}..."
  end

  def created_at
    localize(model.created_at, format: :default)
  end

  def updated_at
    localize(model.updated_at, format: :default)
  end

  def value
    number_to_currency model.value
  end

  def class_name
    t('activerecord.models.bling_order_items.one')
  end
end
