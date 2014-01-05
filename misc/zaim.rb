require 'nokogiri'

# prepare html on https://zaim.net/money / own your risk
# setInterval(function() { if(!$('#readmore button').hasClass('disabled')) $('#readmore').click() }, 5000);
# copy table.table03 as HTML using Web Inspector

html = Nokogiri::HTML(open('/Users/sorah/Documents/zaim.html'),nil,'UTF-8')

table = html.at('table.table03')

categories = {}
sub_categories = {}
places = {}
accounts = {}
proceeded = {}

# ActiveRecord::Base.logger = ActiveSupport::Logger.new($stdout)

ActiveRecord::Base.transaction do
  table.search('tbody tr').each do |tr|
    next if tr.inner_html == "<td colspan=\"8\"></td>\n"
    next if tr.at('th')
    next if tr.at('td.category').text == "\n■\n振替\n"
    next unless tr.at('td.place a')
    url = tr.at('td.date a')['data-url']
    next if proceeded[url]
    d = {
      date: tr.at('td.date a')['data-value'],
      category: tr.at('td.category img')['alt'],
      sub_category: tr.at('td.category').text.lines[2].chomp,
      price: tr.at('td.price').text.gsub(/[^\d]/,''),
      place: tr.at('td.place').text.gsub(/　/, ' ').gsub(/^\s+/,'').gsub(/\s+$/,''),
      account: (tr.at('td.account-s img') || {'alt' => nil})['alt'],
      comment: tr.at('td.comment').text
    }
    d[:place] = nil if /muted/ === tr.at('td.place a')['class']
    d[:comment] = nil if /muted/ === tr.at('td.comment a')['class']

    category = (categories[d[:category]] ||= Category.where(name: d[:category]).first_or_create)
    sub_categories[category.name] ||= {}

    sub_category = (sub_categories[category.name][d[:sub_category]] ||= category.sub_categories.where(name: d[:sub_category]).first_or_create)

    if d[:place]
      place = (places[d[:place]] ||= Place.where(name: d[:place]).first_or_create)
    else
      place = nil
    end

    account = (accounts[d[:account]] ||= Account.where(name: d[:account]).first_or_create)

    Expense.create(
      amount: d[:price].to_i,
      comment: d[:comment],
      paid_at: Time.parse("#{d[:date]} 00:00:00"),
      place: place,
      sub_category: sub_category,
      account: account
    )
    proceeded[url] = true
  end
end
