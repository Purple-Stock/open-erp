# == Schema Information
#
# Table name: post_data
#
#  id          :bigint           not null, primary key
#  cep         :string
#  client_name :string
#  post_code   :string
#  post_type   :string
#  send_date   :datetime
#  state       :string
#  value       :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PostDatum < ApplicationRecord
end
