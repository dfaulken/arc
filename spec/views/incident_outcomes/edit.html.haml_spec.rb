require 'rails_helper'

RSpec.describe "incident_outcomes/edit", type: :view do
  before(:each) do
    @incident_outcome = assign(:incident_outcome, IncidentOutcome.create!(
      incident_id: 1,
      driver_id: 1,
      received_warning: false,
      penalty_points: 1,
      explanation: "MyText",
      published: false
    ))
  end

  it "renders the edit incident_outcome form" do
    render

    assert_select "form[action=?][method=?]", incident_outcome_path(@incident_outcome), "post" do

      assert_select "input[name=?]", "incident_outcome[incident_id]"

      assert_select "input[name=?]", "incident_outcome[driver_id]"

      assert_select "input[name=?]", "incident_outcome[received_warning]"

      assert_select "input[name=?]", "incident_outcome[penalty_points]"

      assert_select "textarea[name=?]", "incident_outcome[explanation]"

      assert_select "input[name=?]", "incident_outcome[published]"
    end
  end
end
