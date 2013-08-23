class Payment < ActiveRecord::Base
  has_one :bill
  belongs_to :subcategory
  belongs_to :place
  belongs_to :account

  scope :in, ->(fiscal_date_or_range) do
    if fiscal_date_or_range.respond_to?(:range_in_time)
      range = fiscal_date_or_range.range_in_time
    else
      range = fiscal_date_or_range
    end

    where(paid_at: range)
  end

  class << self
    def in_this_month
      self.in FiscalDate.current_month
    end

    def in_this_week
      self.in FiscalDate.current_week
    end

    def in_a_month_of(day)
      self.in FiscalDate.locate_month(day)
    end

    def in_a_week_of(day)
      self.in FiscalDate.locate_week(day)
    end
  end

  def category
    # TODO
  end
end
