# frozen_string_literal: true

# == Schema Information
#
# Table name: bling_module_situations
#
#  id           :bigint           not null, primary key
#  color        :string
#  name         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  inherited_id :integer
#  module_id    :integer          not null
#  situation_id :integer          not null
#
# Indexes
#
#  index_bling_module_situations_on_situation_id  (situation_id) UNIQUE
#
class BlingModuleSituation < ApplicationRecord
  validates :situation_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :module_id, presence: true
end
