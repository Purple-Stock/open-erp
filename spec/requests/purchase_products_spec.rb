# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PurchaseProduct' do
  describe 'POST /purchase_products/save_inventory' do
    include_context 'with user signed in'

    let!(:product) { FactoryBot.create(:product, account_id: user.account.id) }

    context 'when valid' do
      it 'creates purchase product' do
        expect do
          post save_inventory_path, params: { product_id: product.id, quantity: 1 }
        end.to change(PurchaseProduct, :count).by(1)
      end

      it 'redirects to product' do
        post save_inventory_path, params: { product_id: product.id, quantity: 1 }
        expect(response).to redirect_to(product_path(product))
      end
    end

    context 'when invalid quantity' do
      it 'does not create purchase product' do
        expect do
          post save_inventory_path, params: { product_id: product.id, quantity: 0 }
        end.to change(PurchaseProduct, :count).by(0)
      end

      it 'is unprocessable entity' do
        post save_inventory_path, params: { product_id: product.id, quantity: 0 }
        expect(response.status).to eq(422)
      end
    end
  end
end
