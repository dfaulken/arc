require 'rails_helper'

RSpec.describe "incidents/index", type: :view do
  before(:each) do
    assign(:incidents, [
      Incident.create!(
        race_id: 2,
        lap_number: 3,
        reported_by: "Reported By",
        drivers_involved: "Drivers Involved",
        description: "MyText"
      ),
      Incident.create!(
        race_id: 2,
        lap_number: 3,
        reported_by: "Reported By",
        drivers_involved: "Drivers Involved",
        description: "MyText"
      )
    ])
  end

  it "renders a list of incidents" do
    render
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: "Reported By".to_s, count: 2
    assert_select "tr>td", text: "Drivers Involved".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
