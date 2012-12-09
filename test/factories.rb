FactoryGirl.define do
  factory :performance do
    title "Performance Title"
    text "Performance Text"
    video_script "video_script"
  end

  factory :video do
    title "Video title"
    association :performance
    script "video_script"
    text "Video Text"
  end

  factory :pic do
    association :performance
  end
end