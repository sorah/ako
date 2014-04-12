require 'time'

# rubocop:disable RescueModifier
module DatetimeParameterHandler
  private

  def process_time_param(str)
    case str
    when /\A\d+\z/
      Time.at(str.to_i)
    else
      Time.xmlschema(str) rescue Time.parse(str)
    end.localtime
  rescue ArgumentError
    nil
  end
end
