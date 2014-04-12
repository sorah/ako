class Option < ActiveRecord::Base
  class << self
    def [](k)
      Rails.cache.fetch("options_#{k}") do
        self.where(tag: k).first.try(:value) || default[k]
      end
    end

    def []=(k, v)
      dump = Marshal.dump(v)
      a = self.create_with(val: dump) \
              .find_or_create_by!(tag: k)
      a.update_attributes!(val: dump)
      Rails.cache.write "options_#{k}", v, expires_in: 10.minutes
      v
    end

    def delete(k)
      self.where(tag: k).destroy_all
      Rails.cache.delete("options_#{k}")
    end

    def default(h = nil)
      @defaults ||= {}
      @defaults.merge!(h) if h
      @defaults
    end
  end

  def key
    self.tag
  end

  def value
    Marshal.load val
  end

  def value=(o)
    Marshal.dump(o)
  end

  default month_starts: 1, week_starts: 0
end
