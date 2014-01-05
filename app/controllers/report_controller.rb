class ReportController < ApplicationController
  def monthly_index
    month = FiscalDate.current_month
    redirect_to monthly_report_path(year: month.year, month: month.number)
  end

  def weekly_index
    week = FiscalDate.current_week
    redirect_to weekly_report_path(year: week.month.year, month: week.month.number, weekno: week.number)
  end

  def monthly
    year, month = params[:year], params[:month]
    if year && month
      @report = Report::Month.new(year, month)
    else
      render status: :bad_request
    end
  end

  def weekly
    year, month, number = params[:year], params[:month], params[:weekno]
    if year && month && number
      # weekno is 0-origin
      @report = Report::Week.new(year, month, number.to_i - 1)
    else
      render status: :bad_request
    end
  end

  def daily
    year, month, day = params[:year], params[:month], params[:day]
    if year && month && day
      date = Date.new(year.to_i, month.to_i, day.to_i)
    else
      date = Date.today
    end

    @report = Report::Day.new(date)
  end
end
