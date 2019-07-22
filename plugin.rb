# name: discourse-zspace
# about: Customisations required for zspace
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/angusmcleod/discourse-zspace

register_asset 'stylesheets/common/zspace.scss'

register_svg_icon "download" if respond_to?(:register_svg_icon)

after_initialize do
  add_to_serializer(:topic_view, :activity_file) {
    if object.topic.custom_fields['activity_file']
      begin
        file = JSON.parse(object.topic.custom_fields['activity_file'])
        file["url"]
      rescue JSON::ParserError => e
        puts e
      end 
    end
  }
  add_to_serializer(:topic_list_item, :activity_file) {
    if object.custom_fields['activity_file']
      begin
        file = JSON.parse(object.custom_fields['activity_file'])
        file["url"]
      rescue JSON::ParserError => e
        puts e
      end
    end
  }
end
