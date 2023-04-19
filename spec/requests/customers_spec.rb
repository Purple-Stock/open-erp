# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Customers", type: :request do

	# before :each do
	# 	@file = fixture_file_upload('customers.csv', 'text/csv')
	# end

  # describe "POST /import" do
  #   it "returns http found" do
  #     post import_customers_path
  #     expect(response).to have_http_status(:found)
  #   end  

	# 	let!(:account) { create(:account) }
	# 	let(:csv_file) { fixture_file_upload(file_fixture('customers.csv')) }

	# 	#subject(:http_request) { post import_customers_path, params: { file: csv_file } }

	# 	#expect(response).to have_http_status(:found)
	# 	it "can upload a cvs file" do
	# 		login_user(account.user)
	# 		# file = Hash.new
	# 		# file['file'] = @file
	# 		# post import_customers_path, params: { uploads: { file: file } }
	# 		post import_customers_path, params: { file: csv_file }
	# 		expect(response.status).to eq(302) #redirect
	# 	end
  # end  

	# describe 'Services::StudentsUploader' do 
	# 	it 'creates students' do 
	# 		Tempfile.open(['students.csv', '.csv']) do |temp|
	# 			 CSV.open(temp, 'wb', col_sep: ';', headers: true) do |csv|
	# 				 csv << ['email', 'name']
	# 				 csv << ['student@example.com', 'Student Name']
	# 			 end
	
	# 			 result = described_class.call(temp)
	
	# 			 expect(result[:count]).to eq(1)
	# 			 expect(Student.count).to eq(1)
	# 		 end
	# 	end
	# end
end