require 'rails_helper'

RSpec.describe "incidents/show", type: :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      race_id: 2,
      lap_number: 3,
      reported_by: "Reported By",
      drivers_involved: "Drivers Involved",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Reported By/)
    expect(rendered).to match(/Drivers Involved/)
    expect(rendered).to match(/MyText/)
  end
end
