# frozen_string_literal: true

# StatusUpdateJob raises to update massive number of orders with old status
# Tip: use it with
# Model.find_in_batches(batch_size: small_number) do |batch_group_array|
#   bling_order_ids = batch_group_array.map(&:bling_order_id)
#   StatusUpdateJob.perform_later(bling_order_ids, new_status, account_id)
# end
class StatusUpdateJob < ApplicationJob
  queue_as :status_update
  retry_on StandardError, attempts: 10, wait: :exponentially_longer

  def perform(bling_order_ids, new_status, account_id)
    Services::Bling::UpdateOrderStatus.new(tenant: account_id, order_ids: bling_order_ids, new_status:).call
  end
end
