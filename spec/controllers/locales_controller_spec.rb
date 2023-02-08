require 'rails_helper'

RSpec.describe LocalesController, type: :controller do

	# after(:each) do
  #   I18n.locale = :'pt-BR'
  # end

	
	# it "should check if the locale is set to default language pt-BR" do
	# 	get :set_locale, params: {locale: 'default' }
	# 	expect(response).to have_http_status(:found)
		
	# 	#expect(I18n.locale).to eq(:"pt-BR")
	# end

	it "should check if the locale is set to default language pt-BR" do
		get :set_locale, params: {locale: 'default' }		
		expect(I18n.default_locale).to eq(:"pt-BR")
	end

	# it "should check if the locale is :'pt-BR'" do
  #   get :check_for_locale, locale: :'pt-BR'
  #   expect(I18n.locale).to eq(:'pt-BR')
  # end

end