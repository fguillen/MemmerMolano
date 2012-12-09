class Pic < ActiveRecord::Base
  attr_protected nil
  belongs_to :performance

  has_attached_file(
    :thumb,
    :styles => {
      :full => "1200x900>",
      :slider => "640x427>",
      :admin => "303x203>"
    },
    :path => ":rails_root/public/uploads/:rails_env/performances/pic_:id_:style.:extension",
    :url => "/uploads/:rails_env/performances/pic_:id_:style.:extension"
  )


  validates_attachment_presence :thumb

  scope :by_position, order("position asc")
end
