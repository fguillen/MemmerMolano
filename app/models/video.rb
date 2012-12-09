class Video < ActiveRecord::Base
  belongs_to :performance
  attr_protected nil

  before_validation :initialize_position

  has_attached_file(
    :pic,
    :styles => {
      :slider => "213x117>",
      :big => "640x427>"
    },
    :path => ":rails_root/public/uploads/:rails_env/videos/pic_:id_:style.:extension",
    :url => "/uploads/:rails_env/videos/pic_:id_:style.:extension"
  )

  validates_presence_of :performance_id
  validates_presence_of :title
  validates_presence_of :script
  validates_presence_of :text
  validates_attachment_presence :pic

  scope :by_position, order("position asc")

  def to_json
    {
      :id => id,
      :pic_url => pic(:slider),
      :title => title,
      :text => text,
      :script => script
    }
  end

  def to_param
    "#{id}-#{title}".parameterize
  end

  def initialize_position
    self.position ||= Video.by_position.last ? Video.by_position.last.position + 1 : 1
  end
end
