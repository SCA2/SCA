require "rails_helper"

describe OptionsController do
  describe "routing" do

    it "routes to #new" do
      expect(get("/products/1/options/new")).to route_to("options#new", product_id: "1")
    end

    it "routes to #edit" do
      expect(get("/products/1/options/1/edit")).to route_to("options#edit", product_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post("/products/1/options")).to route_to("options#create", product_id: "1")
    end

    it "routes to #update" do
      expect(patch("/products/1/options/1")).to route_to("options#update", product_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/products/1/options/1")).to route_to("options#destroy", product_id: "1", id: "1")
    end

  end
end
