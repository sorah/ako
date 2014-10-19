csv_path = ENV["ZAIM_CSV"]
abort 'specify $ZAIM_CSV' unless csv_path

categories = {}
sub_categories = {}
places = {}
accounts = {}

ActiveRecord::Base.logger = Logger.new($stdout)

ActiveRecord::Base.transaction do
  File.read(csv_path).each_line.lazy.map(&:chomp).drop(1).map do |line|
    # 日付,方法,カテゴリ,ジャンル,支払元,入金先,"Price (Original)",名前,メモ,Currency,支出,収入,場所
    in_date, in_type, in_category, in_genre, in_from, in_to, in_price, in_name, in_memo, in_currency, in_expense, in_income, in_place =
      line.scan(/(?:"(.+?)"|(.*?)),|(?:"(.+?)"|(.+?))\z/).flatten.compact.map{ |_| _.sub(/""/,?") }

    {
      date: Time.new(*in_date.split(?-).map(&:to_i), 0, 0, 0),
      type: in_type,
      category: in_category,
      genre: in_genre,
      from: in_from,
      to: in_to,
      price: in_price,
      name: in_name,
      memo: in_memo,
      currency: in_currency,
      expense: in_expense,
      income: in_income,
      place: in_place,
    }
  end.select do |entry|
    entry[:type] == 'payment'.freeze
  end.map do |entry|
    category = (categories[entry[:category]] ||= Category.where(name: entry[:category]).first_or_create)
    sub_categories[category.name] ||= {}
    sub_category = (sub_categories[category.name][entry[:genre]] ||=
                    category.sub_categories.where(name: entry[:genre]).first_or_create)

    if entry[:place] && entry[:place] != '-'
      place = (places[entry[:place]] ||= Place.where(name: entry[:place]).first_or_create)
    else
      place = nil
    end

    if entry[:from] && entry[:from] != '-'
      account = (accounts[entry[:from]] ||= Account.where(name: entry[:from]).first_or_create)
    else
      account = nil
    end

    entry.merge(
      category_name: entry[:category],
      category: category,
      sub_category: sub_category,
      category_name: entry[:place],
      account: account,
      place: place,
    )
  end.slice_before([]) do |entry, state|
    prev, state[0] = state[0], entry

    prev &&
    (
      (!prev[:name] || prev[:name].empty?) ||
      (prev[:date] != entry[:date] || prev[:place] != entry[:place])
    )
  end.each do |receipt|
    amount = receipt.map{ |_| _[:price].to_i }.inject(:+)
    expenses = receipt.group_by { |_| _[:sub_category] }.map do |category, entries|
      amount = entries.map{ |_| _[:price].to_i }.inject(:+)
      place, comment, sub_category, account, paid_at =
        entries.first.values_at(*%i(place memo sub_category account date))

      items = entries.map{ |_| {name: _[:name], price: _[:price].to_i} }

      Expense.create(
        amount: amount,
        place: place,
        comment: "#{comment}\n#{items.map{ |_| _[:name] }.join(', ')}".sub(/\A\n/,'').chomp,
        sub_category: sub_category,
        account: account,
        paid_at: paid_at,
        meta: {zaim: items.empty? ? {} : {items: items}}
      )
    end

    same_receipt = expenses.map(&:id)
    expenses.each do |expense|
      expense.meta[:zaim][:same_receipt] = same_receipt.reject { |_| _ == expense.id }
      expense.save!
    end
  end
end
