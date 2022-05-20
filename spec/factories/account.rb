FactoryBot.define do
  factory :account do
    company_name { FFaker::InternetSE.company_name_single_word }

    user { create(:user) }
  end
end

