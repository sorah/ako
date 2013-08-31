class Payment < ActiveRecord::Base
  has_one :bill
  belongs_to :sub_category
  belongs_to :place
  belongs_to :account

  serialize :meta, Hash

  validates_presence_of :amount
  validates_presence_of :paid_at

  # default_scope do
  #   joins(:sub_category).select('*,`sub_categories`.`category_id` AS `category_id`')
  # end

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

  def paid_at
    attributes['paid_at'] ||= Time.now
  end

  def category(reload=nil)
    @category = nil if reload || attributes['category_id'].nil?
    return @category if @category

    @category = Category.joins(:sub_categories) \
                        .where(sub_categories: {id: self.sub_category_id}).first
    attributes['category_id'] = @category.id
    return @category
  end

  def category_id
    attributes['category_id'] ||= category.id
  end
end
