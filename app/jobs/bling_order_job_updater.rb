class BlingOrderJobUpdater < ApplicationJob
  queue_as :bling_order_updater
  retry_on StandardError, attempts: 5, wait: :exponentially_longer

  def perform(record, account_id)
    result = Services::Bling::FindOrder.call(id: record.bling_order_id, order_command: 'find_order', tenant: account_id)
    raise StandardError if result['error'].present?

    record.situation_id = result['data']['situacao']['id']
    record.value = result['data']['total']
    record.alteration_date = Time.zone.today
    return unless record.situation_id_changed?

    record.save!
  end
end
