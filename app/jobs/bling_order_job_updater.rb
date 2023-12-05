class BlingOrderJobUpdater < ApplicationJob
  queue_as :default

  def perform(record, account_id)
    result = Services::Bling::FindOrder.call(id: record.bling_order_id, order_command: 'find_order', tenant: account_id)
    return if result['error'].present?

    record.update({ value: result['data']['total'], situation_id: result['data']['situacao']['id'] })
  end
end