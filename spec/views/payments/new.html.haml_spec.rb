require 'spec_helper'

describe "payments/new" do
  before(:each) do
    assign(:payment, stub_model(Payment,
      :place => "",
      :amount => 1,
      :comment => "MyText",
      :meta => "MyText",
      :subcategory => "",
      :bill => "",
      :account => ""
    ).as_new_record)
  end

  it "renders new payment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", payments_path, "post" do
      assert_select "input#payment_place[name=?]", "payment[place]"
      assert_select "input#payment_amount[name=?]", "payment[amount]"
      assert_select "textarea#payment_comment[name=?]", "payment[comment]"
      assert_select "textarea#payment_meta[name=?]", "payment[meta]"
      assert_select "input#payment_subcategory[name=?]", "payment[subcategory]"
      assert_select "input#payment_bill[name=?]", "payment[bill]"
      assert_select "input#payment_account[name=?]", "payment[account]"
    end
  end
end
