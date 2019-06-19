# name: discourse-zspace
# about: Customisations required for zspace
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/angusmcleod/discourse-zspace

after_initialize do
  add_to_serializer(:topic_view, :activity_file) { JSON.parse(object.topic.custom_fields['activity_file']) }
end
