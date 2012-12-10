class Pic < ActiveRecord::Base
  attr_protected nil
  belongs_to :performance

  before_validation :initialize_position

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

  def initialize_position
    self.position ||= Pic.by_position.last ? Pic.by_position.last.position + 1 : 1
  end

  def to_json
    {
      "id" => id,
      "file_url" => thumb(:admin)
    }
  end
end
