class Account < ActiveRecord::Base
  has_many :payments

  serialize :meta, Hash

  validates_presence_of :name

  def icon
    attributes["icon"] || 'usd'
  end
end
