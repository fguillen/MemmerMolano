class Performance < ActiveRecord::Base
  attr_protected nil

  scope :by_position, order("position asc")
end
