require 'spec_helper'

describe ReportController do
  describe "GET 'monthly_index'" do
    it "redirects to report of current_month" do
      get :monthly_index

      year, month = FiscalDate.current_month.year, FiscalDate.current_month.month
      expect(response).to redirect_to(monthly_report_path(year: year, month: month))
    end
  end

  describe "GET 'weekly_index'" do
    it "redirects to report of current week" do
      get :weekly_index

      week = FiscalDate.current_week
      year, month, weekno = week.month.year, week.month.number, week.number
      expect(response).to redirect_to(
        weekly_report_path(year: year, month: month, weekno: weekno))
    end
  end

  describe "GET 'monthly'" do
    context "with year and month" do
      it "assigns report of specified month" do
        get :monthly, year: 2013, month: 10
        expect(assigns(:report)).to be_a_kind_of(Report::Month)
        expect(assigns(:report).year).to eq 2013
        expect(assigns(:report).month).to eq 10
      end
    end
  end

  describe "GET 'weekly'" do
    context "with year, month and weekno" do
      it "assigns report of specified month" do
        get :weekly, year: 2013, month: 10, weekno: 2
        expect(assigns(:report)).to be_a_kind_of(Report::Week)
        expect(assigns(:report).year).to eq 2013
        expect(assigns(:report).month).to eq 10
        expect(assigns(:report).number).to eq 2
      end
    end
  end

  describe "GET 'daily'" do
    context "with year, month and day" do
      it "assigns report of specified day" do
        get :daily, year: 2013, month: 10, day: 2
        expect(assigns(:report)).to be_a_kind_of(Report::Day)
        expect(assigns(:report).date).to eq Date.new(2013, 10, 2)
      end
    end
  end
end
