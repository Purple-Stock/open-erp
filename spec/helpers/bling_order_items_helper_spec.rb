# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlingOrderItemsHelper, type: :helper do
  describe '#link_to_external_bling_order' do
    context 'when bling_order_id is present' do
      it 'has complete link to external target blank tag' do
        expect(helper.link_to_external_bling_order('12345'))
          .to eq('<a target="_blank" rel="noopener" href="https://www.bling.com.br/b/vendas.php#edit/12345">12345</a>')
      end
    end
  end
end
