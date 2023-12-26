require "rails_helper"

RSpec.describe ProductionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/productions").to route_to("productions#index")
    end

    it "routes to #new" do
      expect(get: "/productions/new").to route_to("productions#new")
    end

    it "routes to #show" do
      expect(get: "/productions/1").to route_to("productions#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/productions/1/edit").to route_to("productions#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/productions").to route_to("productions#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/productions/1").to route_to("productions#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/productions/1").to route_to("productions#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/productions/1").to route_to("productions#destroy", id: "1")
    end
  end
end
