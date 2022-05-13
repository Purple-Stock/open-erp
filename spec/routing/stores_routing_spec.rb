require "rails_helper"

RSpec.describe StoresController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/stores").to route_to("stores#index")
    end

    it "routes to #new" do
      expect(get: "/stores/new").to route_to("stores#new")
    end

    it "routes to #show" do
      expect(get: "/stores/1").to route_to("stores#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/stores/1/edit").to route_to("stores#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/stores").to route_to("stores#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/stores/1").to route_to("stores#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/stores/1").to route_to("stores#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/stores/1").to route_to("stores#destroy", id: "1")
    end
  end
end
