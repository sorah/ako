class Bill < ActiveRecord::Base
  belongs_to :payment
end
