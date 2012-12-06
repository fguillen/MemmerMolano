class Performance < ActiveRecord::Base
  attr_protected nil
  has_many :pics

  scope :by_position, order("position asc")
end
