require 'rails_helper'

RSpec.describe "incident_outcomes/index", type: :view do
  before(:each) do
    assign(:incident_outcomes, [
      IncidentOutcome.create!(
        incident_id: 2,
        driver_id: 3,
        received_warning: false,
        penalty_points: 4,
        explanation: "MyText",
        published: false
      ),
      IncidentOutcome.create!(
        incident_id: 2,
        driver_id: 3,
        received_warning: false,
        penalty_points: 4,
        explanation: "MyText",
        published: false
      )
    ])
  end

  it "renders a list of incident_outcomes" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
