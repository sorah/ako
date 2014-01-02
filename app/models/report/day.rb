class Report
  class Day
    include Report::Common

    def initialize(*args)
      case args.size
      when 3
        @date = Date.new(*args)
      when 1
        unless args.first.kind_of?(Date)
          raise TypeError, "passed object is not Date"
        end

        @date = args.first
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1,3)"
      end
    end

    attr_reader :date
    def year()  @date.year  end
    def month() @date.month end
    def day()   @date.day   end

    def expenses
      Expense.on(@date)
    end
  end
end
