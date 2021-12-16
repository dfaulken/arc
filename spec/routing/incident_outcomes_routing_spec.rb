require "rails_helper"

RSpec.describe IncidentOutcomesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/incident_outcomes").to route_to("incident_outcomes#index")
    end

    it "routes to #new" do
      expect(get: "/incident_outcomes/new").to route_to("incident_outcomes#new")
    end

    it "routes to #show" do
      expect(get: "/incident_outcomes/1").to route_to("incident_outcomes#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/incident_outcomes/1/edit").to route_to("incident_outcomes#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/incident_outcomes").to route_to("incident_outcomes#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/incident_outcomes/1").to route_to("incident_outcomes#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/incident_outcomes/1").to route_to("incident_outcomes#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/incident_outcomes/1").to route_to("incident_outcomes#destroy", id: "1")
    end
  end
end
