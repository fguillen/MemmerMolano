class Video < ActiveRecord::Base
  belongs_to :performance
  attr_protected nil

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
  validates_presence_of :pic

  scope :by_position, order("position asc")
end
