require "rails_helper"

describe FeaturesController do
  describe "routing" do

    it "routes to #new" do
      expect(get("/products/1/features/new")).to route_to("features#new", product_id: "1")
    end

    it "routes to #edit" do
      expect(get("/products/1/features/1/edit")).to route_to("features#edit", product_id: "1", id: "1")
    end

    it "routes to #create" do
      expect(post("/products/1/features")).to route_to("features#create", product_id: "1")
    end

    it "routes to #update" do
      expect(patch("/products/1/features/1")).to route_to("features#update", product_id: "1", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("/products/1/features/1")).to route_to("features#destroy", product_id: "1", id: "1")
    end

  end
end
