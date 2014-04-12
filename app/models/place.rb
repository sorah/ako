class Place < ActiveRecord::Base
  has_many :expenses
  has_many :bills

  scope :search_by_name, ->(query) { where('name like ?', query.gsub(/[%_]/, '\\\\\0') + '%') }

  def self.candidates_for_expense(query, name_only: false)
    return [] unless query

    candidates = search_by_name(query)
    candidates = candidates.select(:id, :name) if name_only

    # For Japanese (CJK Unified Ideographs = \u4e00 - 9fff)
    if candidates.empty? && /[\u4e00-\u9fff]|\p{Hiragana}|\p{Katakana}/ =~ query
      query = query \
        .gsub(/[a-zａ-ｚ]$/, '') # Incomplete romaji
        .gsub(/[▼▽].*$/, '') # For SKK users

      candidates = search_by_name(query)
      candidates = candidates.select(:id, :name) if name_only
    end

    candidates
  end
end
