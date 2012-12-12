FactoryGirl.define do
  factory :performance do
    title "Performance Title"
  end

  factory :video do
    title "Video title"
    pic { File.new("#{Rails.root}/test/fixtures/images/extras1.jpg") }
    association :performance
    script "video_script"
    text "Video Text"
  end

  factory :pic do
    association :performance
    thumb { File.new("#{Rails.root}/test/fixtures/images/1.jpg") }
  end
end