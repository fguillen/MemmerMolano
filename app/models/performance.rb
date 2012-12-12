class Performance < ActiveRecord::Base
  attr_protected nil
  has_many :pics
  has_many :videos

  before_validation :initialize_position

  validates_presence_of :title, :if => Proc.new{ |e| e.form_section == "new" || e.form_section == "details" }
  validates_presence_of :text, :if => Proc.new{ |e| e.form_section == "details" }
  validates_presence_of :video_script, :if => Proc.new{ |e| e.form_section == "video_main" }
  validates_presence_of :video_text, :if => Proc.new{ |e| e.form_section == "video_main" }
  validates_presence_of :position

  scope :by_position, order("position asc")

  attr_accessor :form_section

  def to_param
    "#{id}-#{title}".parameterize
  end

  def initialize_position
    self.position ||= Performance.by_position.last ? Performance.by_position.last.position + 1 : 1
  end
end
