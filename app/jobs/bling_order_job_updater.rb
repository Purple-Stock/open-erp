class BlingOrderJobUpdater < ApplicationJob
  queue_as :default
  retry_on StandardError, attempts: 5, wait: :exponentially_longer

  def perform(record, account_id)
    result = Services::Bling::FindOrder.call(id: record.bling_order_id, order_command: 'find_order', tenant: account_id)
    raise StandardError if result['error'].present?

    record.update({ value: result['data']['total'], situation_id: result['data']['situacao']['id'] })
  end
end
