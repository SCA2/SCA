require "rails_helper"

describe OrdersController do
  describe "routing" do

    it "routes to #subregion_options" do
      expect(get("/orders/subregion_options")).to route_to("orders#subregion_options")
    end

    it "routes to #express" do
      expect(get("/orders/express")).to route_to("orders#express")
    end

    it "routes to #create_express" do
      expect(get("/orders/create_express")).to route_to("orders#create_express")
    end

    it "routes to #addresses" do
      expect(get("/orders/1/addresses")).to route_to("orders#addresses", id: "1")
    end

    it "routes to #create_addresses" do
      expect(post("/orders/1/create_addresses")).to route_to("orders#create_addresses", id: "1")
    end

    it "routes to #shipping" do
      expect(get("/orders/1/shipping")).to route_to("orders#shipping", id: "1")
    end

    it "routes to #update_shipping" do
      expect(patch("/orders/1/update_shipping")).to route_to("orders#update_shipping", id: "1")
    end

    it "routes to #payment" do
      expect(get("/orders/1/payment")).to route_to("orders#payment", id: "1")
    end

    it "routes to #update_payment" do
      expect(patch("/orders/1/update_payment")).to route_to("orders#update_payment", id: "1")
    end

    it "routes to #confirm" do
      expect(get("/orders/1/confirm")).to route_to("orders#confirm", id: "1")
    end

    it "routes to #update_confirm" do
      expect(patch("/orders/1/update_confirm")).to route_to("orders#update_confirm", id: "1")
    end

    it "routes to #index" do
      expect(get("/orders")).to route_to("orders#index")
    end

    it "routes to #new" do
      expect(get("/orders/new")).to route_to("orders#new")
    end

    it "routes to #show" do
      expect(get("/orders/1")).to route_to("orders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("/orders/1/edit")).to route_to("orders#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("/orders")).to route_to("orders#create")
    end

    it "routes to #update" do
      expect(patch("/orders/1")).to route_to("orders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/orders/1")).to route_to("orders#destroy", id: "1")
    end

  end
end
