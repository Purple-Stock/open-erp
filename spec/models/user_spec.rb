# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  company_name           :string
#  cpf_cnpj               :string
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#create' do
    context 'when valid' do
      subject(:create_valid) do
        FactoryBot.create(:user)
      end

      it 'creates user' do
        expect do
          create_valid
        end.to change(described_class, :count).by(1)
      end

      it 'creates account' do
        expect do
          create_valid
        end.to change(Account, :count).by(1)
      end
    end
  end
end
