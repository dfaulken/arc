require 'rails_helper'

RSpec.describe "incidents/new", type: :view do
  before(:each) do
    assign(:incident, Incident.new(
      race_id: 1,
      lap_number: 1,
      reported_by: "MyString",
      drivers_involved: "MyString",
      description: "MyText"
    ))
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", incidents_path, "post" do

      assert_select "input[name=?]", "incident[race_id]"

      assert_select "input[name=?]", "incident[lap_number]"

      assert_select "input[name=?]", "incident[reported_by]"

      assert_select "input[name=?]", "incident[drivers_involved]"

      assert_select "textarea[name=?]", "incident[description]"
    end
  end
end
