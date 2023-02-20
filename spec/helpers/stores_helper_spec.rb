require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the StoresHelper. For example:
#
# describe StoresHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe StoresHelper, type: :helper do
  describe '#create' do
    let(:store) { create(:store) }

    it 'should create a store' do
      expect(store).to be_valid
    end
  end

  describe '#update' do
    let(:store) { create(:store) }

    it 'should update a store' do
      store.name = 'New Name'
      expect(store).to be_valid
    end
  end

  describe '#destroy' do
    let(:store) { create(:store) }

    it 'should destroy a store' do
      store.destroy
      expect(store).to be_valid
    end
  end

  describe '#index' do
    let(:store) { create(:store) }

    it 'should list all stores' do
      expect(store).to be_valid
    end
  end
end
