class Report
  class Week
    include Report::Common

    def initialize(*args)
      case args.size
      when 3
        initialize_with_integers(*args)
      when 1
        initialize_with_week_object(*args)
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1,3)"
      end
    end

    def initialize_with_integers(*args)
      @fiscal_week = FiscalDate::Week.in(*args[0, 2])[args[-1].to_i]
    end

    def initialize_with_week_object(week)
      unless week.kind_of?(FiscalDate::Week)
        raise TypeError, 'passed object is not FiscalDate::Week'
      end

      @fiscal_week = week
    end

    attr_reader :fiscal_week
    def year()   @fiscal_week.month.year end
    def month()  @fiscal_week.month.month end
    def number() @fiscal_week.number end

    def expenses
      Expense.in(@fiscal_week)
    end

    def days
      @fiscal_week.days.map { |_| Report::Day.new(_) }
    end
  end
end
