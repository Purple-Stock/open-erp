require "rails_helper"

RSpec.describe SheinOrdersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/shein_orders").to route_to("shein_orders#index")
    end

    it "routes to #new" do
      expect(get: "/shein_orders/new").to route_to("shein_orders#new")
    end

    it "routes to #show" do
      expect(get: "/shein_orders/1").to route_to("shein_orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/shein_orders/1/edit").to route_to("shein_orders#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/shein_orders").to route_to("shein_orders#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/shein_orders/1").to route_to("shein_orders#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/shein_orders/1").to route_to("shein_orders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/shein_orders/1").to route_to("shein_orders#destroy", id: "1")
    end
  end
end
