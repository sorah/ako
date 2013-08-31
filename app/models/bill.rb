class Bill < ActiveRecord::Base
  belongs_to :payment

  serialize :meta, Hash
end
