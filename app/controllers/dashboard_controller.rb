class DashboardController < ApplicationController
  def index
    month = FiscalDate.current_month
    @monthly_report = Report::Month.new(month)
    @expense = Expense.new
  end
end
