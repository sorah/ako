class Report
  class Day
    include Report::Common

    def initialize(*args)
      case args.size
      when 3
        initialize_with_integers(*args)
      when 1
        initialize_with_date_object(*args)
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1,3)"
      end
    end

    def initialize_with_integers(*args)
      @date = Date.new(*args.map(&:to_i))
    end

    def initialize_with_date_object(date)
      raise TypeError, 'passed object is not Date' unless date.kind_of?(Date)

      @date = date
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
