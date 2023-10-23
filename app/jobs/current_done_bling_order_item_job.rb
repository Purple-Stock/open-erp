# frozen_string_literal: true

class CurrentDoneBlingOrderItemJob < BlingOrderItemCreatorBaseJob
  DONE_STATUSES = [BlingOrderItem::Status::CHECKED, BlingOrderItem::Status::VERIFIED].freeze

  def perform(account_id)
    @alteration_date = Date.today.strftime('%Y-%m-%d')
    options = { dataAlteracaoInicial: alteration_date }
    @account_id = account_id
    begin
      DONE_STATUSES.each do |status|
        orders = Services::Bling::Order.call(order_command: 'find_orders', tenant: account_id,
                                             situation: status, options: options)
        orders = orders['data']

        create_orders(orders)
      end
    rescue StandardError => e
      Rails.logger.error(e.message)
    end
  end
end
