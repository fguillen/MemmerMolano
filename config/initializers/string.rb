class String
  def to_md
    BlueCloth.new( self ).to_html.html_safe
  end
end