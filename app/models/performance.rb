class Performance < ActiveRecord::Base
  attr_protected nil
  has_many :pics
  has_many :videos

  before_validation :initialize_position

  validates_presence_of :title
  validates_presence_of :position

  scope :by_position, order("position asc")

  def to_param
    "#{id}-#{title}".parameterize
  end

  def initialize_position
    self.position ||= Performance.by_position.last ? Performance.by_position.last.position + 1 : 1
  end
end
