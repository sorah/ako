require 'spec_helper'

describe "payments/index" do
  before(:each) do
    assign(:payments, [
      stub_model(Payment,
        :place => "",
        :amount => 1,
        :comment => "MyText",
        :meta => "MyText",
        :subcategory => "",
        :bill => "",
        :account => ""
      ),
      stub_model(Payment,
        :place => "",
        :amount => 1,
        :comment => "MyText",
        :meta => "MyText",
        :subcategory => "",
        :bill => "",
        :account => ""
      )
    ])
  end

  it "renders a list of payments" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
