module ApplicationHelper
  include Pagy::Frontend

  def page_title
    content_for(:page_title) || Rails.application.class.to_s.split('::').first
  end

  def crud_actions
    %w[index show new edit create update]
  end

  def active_nav_item(controller, actions)
    'active' if active_actions?(controller, actions)
  end

  def sort_link_turbo(attribute, *args)
    sort_link(attribute, *args.push({}, { data: { turbolinks_action: 'replace' } }))
  end

  def icon(klass, text = nil)
    icon_tag = tag.i(class: klass)
    text_tag = tag.span text
    text ? tag.span(icon_tag + text_tag) : icon_tag
  end

  def np(number, options = {})
    number_with_precision number, options
  end

  def nd(number, options = {})
    number_with_delimiter number, options
  end
  # R$1234567890,50
  def nc(value)
    number_to_currency(value, unit: "R$", separator: ",", delimiter: "")
  end
  # date format "%d/%m/%Y %H:%m"
  def df(date)
    date.strftime("%d/%m/%Y %H:%m")
  end

  # date format "%d/%m/%Y %H:%m"
  def display_status(status)
    if status
      "<span class='badge bg-success fs-4 text-light'>#{I18n.t('active_status.active')}</span>"
    else
      "<span class='badge bg-danger fs-4 text-light'>#{I18n.t('active_status.inactive')}</span>"
    end
  end

  def localize(object, options = {})
    super(object, options) if object
  end

  alias l localize

  private

  def active_actions?(controller, actions)
    params[:controller].include?(controller) && actions.include?(params[:action])
  end
end
