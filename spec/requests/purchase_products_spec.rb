# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PurchaseProduct' do
  describe 'POST purchase_products_path' do
    include_context 'with user signed in'

    let!(:product) { FactoryBot.create(:product, account_id: user.account.id) }

    context 'when valid' do
      it 'creates purchase product' do
        expect do
          post purchase_products_path, params: { purchase_product:
                                                   { product_id: product.id, quantity: 1,
                                                     account_id: user.account.id } }
        end.to change(PurchaseProduct, :count).by(1)
      end

      it 'redirects to product' do
        post purchase_products_path, params: { purchase_product:
                                                 { product_id: product.id, quantity: 1,
                                                   account_id: user.account.id } }
        expect(response).to redirect_to(purchase_product_path(PurchaseProduct.last))
      end
    end

    context 'when invalid quantity' do
      it 'does not create purchase product' do
        expect do
          post purchase_products_path, params: { purchase_product:
                                                   { product_id: product.id, quantity: 0,
                                                     account_id: user.account.id } }
        end.to change(PurchaseProduct, :count).by(0)
      end

      it 'is unprocessable entity' do
        post purchase_products_path, params: { purchase_product:
                                                 { product_id: product.id, quantity: 0,
                                                   account_id: user.account.id } }
        expect(response.status).to eq(422)
      end
    end
  end
end
