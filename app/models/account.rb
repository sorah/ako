class Account < ActiveRecord::Base
  has_many :expenses

  serialize :meta, Hash

  validates_presence_of :name

  def icon
    attributes["icon"] || 'usd'
  end

  def icon_class
    "icon-#{self.icon}"
  end
end
