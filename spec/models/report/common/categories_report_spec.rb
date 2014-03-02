require 'spec_helper'

describe Report::Common::CategoriesReport do
  let(:parent_class) do
    Class.new {
      include Report::Common

      def expenses
        Expense.all
      end
    }
  end

  let(:parent_report) { parent_class.new }

  subject { described_class.new(parent_report) }
end
