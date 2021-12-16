require 'rails_helper'

RSpec.describe "incident_outcomes/show", type: :view do
  before(:each) do
    @incident_outcome = assign(:incident_outcome, IncidentOutcome.create!(
      incident_id: 2,
      driver_id: 3,
      received_warning: false,
      penalty_points: 4,
      explanation: "MyText",
      published: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
