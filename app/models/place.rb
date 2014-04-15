class Place < ActiveRecord::Base
  has_many :expenses
  has_many :bills

  scope :search_by_name, ->(query) { where('name like ?', query.gsub(/[%_]/, '\\\\\0') + '%') }

  validates :name, presence: true

  # rubocop:disable CyclomaticComplexity
  def self.candidates_for_expense(query, name_only: false)
    return [] unless query

    candidates = search_by_name(query).select(name_only ? [:id, :name] : '*').load

    # For Japanese (CJK Unified Ideographs = \u4e00 - 9fff)
    if candidates.empty? && /[\u4e00-\u9fff]|\p{Hiragana}|\p{Katakana}/ =~ query
      new_query = query \
        .gsub(/[a-zａ-ｚ]$/, '') # Incomplete romaji
        .gsub(/[▼▽].*$/, '') # For SKK users

      return [] if new_query == query
      candidates = search_by_name(new_query).select(name_only ? [:id, :name] : '*')
    end

    candidates
  end
  # rubocop:enable CyclomaticComplexity
end
