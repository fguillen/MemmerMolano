class Performance < ActiveRecord::Base
  attr_protected nil
  has_many :pics
  has_many :videos

  validates_presence_of :title

  scope :by_position, order("position asc")
end
