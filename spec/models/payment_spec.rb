require 'rails_helper'

RSpec.describe Payment, type: :model do
  let(:account) { create(:account) }
  let(:tailor) { create(:tailor, account: account) }
  let(:production) { create(:production, account: account, tailor: tailor) }

  describe 'associations' do
    it { should belong_to(:production) }
  end

  describe 'validations' do
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than(0) }
    it { should validate_presence_of(:payment_date) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      payment = build(:payment, production: production)
      expect(payment).to be_valid
    end
  end

  describe 'scopes' do
    it 'orders payments by payment date' do
      payment1 = create(:payment, production: production, payment_date: 1.day.ago)
      payment2 = create(:payment, production: production, payment_date: 2.days.ago)
      payment3 = create(:payment, production: production, payment_date: Date.today)

      expect(Payment.order(:payment_date)).to eq([payment2, payment1, payment3])
    end
  end

  describe 'callbacks' do
    it 'updates production total_paid after save' do
      production = create(:production, account: account, tailor: tailor)
      initial_total_paid = production.total_paid

      payment = create(:payment, production: production, amount: 100)

      expect(production.reload.total_paid).to eq(initial_total_paid + 100)
    end

    it 'updates production total_paid after destroy' do
      production = create(:production, account: account, tailor: tailor)
      payment = create(:payment, production: production, amount: 100)
      initial_total_paid = production.reload.total_paid

      payment.destroy

      expect(production.reload.total_paid).to eq(initial_total_paid - 100)
    end
  end
end