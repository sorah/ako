class Report
  class Week
    include Report::Common

    def initialize(*args)
      case args.size
      when 3
        @fiscal_week = FiscalDate::Week.in(*args[0, 2])[args[-1].to_i]
      when 1
        unless args.first.kind_of?(FiscalDate::Week)
          raise TypeError, "passed object is not FiscalDate::Week"
        end

        @fiscal_week = args.first
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1,3)"
      end
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
