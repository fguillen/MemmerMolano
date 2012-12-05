FactoryGirl.define do
  factory :performance do
    title "Performance Title"
    text "Performance Text"
    video_script "video_script"
    position 0
  end

  factory :video do
    title "Video title"
    association :performance
    script "video_script"
    text "Video Text"
    position 0
  end
end