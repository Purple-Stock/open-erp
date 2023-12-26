require "rails_helper"

RSpec.describe TailorsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/tailors").to route_to("tailors#index")
    end

    it "routes to #new" do
      expect(get: "/tailors/new").to route_to("tailors#new")
    end

    it "routes to #show" do
      expect(get: "/tailors/1").to route_to("tailors#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/tailors/1/edit").to route_to("tailors#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/tailors").to route_to("tailors#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/tailors/1").to route_to("tailors#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/tailors/1").to route_to("tailors#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/tailors/1").to route_to("tailors#destroy", id: "1")
    end
  end
end
