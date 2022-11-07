# frozen_string_literal: true

# == Schema Information
#
# Table name: simplo_clients
#
#  id         :bigint           not null, primary key
#  age        :integer
#  name       :string
#  order_date :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SimploClient < ApplicationRecord
end
