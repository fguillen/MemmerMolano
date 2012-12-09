video_script = <<-eos
  <iframe src="http://blip.tv/play/hMxqgvvlBgA.html?p=1" width="640" height="360" frameborder="0" allowfullscreen></iframe>
  <embed type="application/x-shockwave-flash" src="http://a.blip.tv/api.swf#hMxqgvvlBgA" style="display:none"></embed>
eos

ActiveRecord::Base.transaction do
  5.times.each do |index|
    performance =
      Performance.create!(
        :title => Faker::Lorem.sentence,
        :text => Faker::Lorem.paragraphs,
        :video_script => video_script,
        :video_text => Faker::Lorem.paragraph,
        :position => index
      )
    puts "Performance created: '#{performance.title}'"
  end

  20.times.each do |index|
    performance = Performance.all.sample
    pic =
      Pic.create!(
        :performance => performance,
        :position => index,
        :thumb => File.open("#{Rails.root}/test/fixtures/images/#{(index%2)+1}.jpg")
      )
    puts "Pic created in performance: '#{performance.title}'"
  end

  30.times.each do |index|
    performance = Performance.all.sample
    video =
      Video.create!(
        :performance => performance,
        :position => index,
        :title => Faker::Lorem.sentence,
        :text => Faker::Lorem.paragraph,
        :script => video_script,
        :pic => File.open("#{Rails.root}/test/fixtures/images/extras#{(index%2)+1}.jpg")
      )
    puts "Video created in performance: '#{performance.title}'"
  end
end