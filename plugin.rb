# name: discourse-zspace
# about: Customisations required for zspace
# version: 0.1
# authors: Angus McLeod
# url: https://github.com/angusmcleod/discourse-zspace

register_asset 'stylesheets/common/zspace.scss'

register_svg_icon "download" if respond_to?(:register_svg_icon)

after_initialize do
  add_to_serializer(:topic_view, :zspace_upload) {
    if object.topic.custom_fields['zspace_upload']
      begin
        JSON.parse(object.topic.custom_fields['zspace_upload'])
      rescue JSON::ParserError => e
        puts e
      end 
    end
  }

  TopicList.preloaded_custom_fields << "zspace_upload" if TopicList.respond_to? :preloaded_custom_fields

  add_to_serializer(:topic_list_item, :zspace_upload) {
    if object.custom_fields['zspace_upload']
      begin
        JSON.parse(object.custom_fields['zspace_upload'])
      rescue JSON::ParserError => e
        puts e
      end
    end
  }

  ::PostRevisor.track_topic_field(:zspace_upload) do |tc, zspace_upload|
      old_zspace_upload = tc.topic.custom_fields['zspace_upload']
      if tc.record_change('zspace_upload', old_zspace_upload, zspace_upload)
        begin
          old_upload_id = JSON.parse(old_zspace_upload)["id"]
          Upload.where(id: old_upload_id).destroy_all
        rescue JSON::ParserError => e
          puts e
        end
        unless zspace_upload.blank?  
          zspace_upload.permit!
          tc.topic.custom_fields['zspace_upload'] = zspace_upload.to_h
        else
          tc.topic.custom_fields['zspace_upload'] = ""
        end
      end
  end
  
  module CommunityUploadsAllowEdits
    def can_edit_topic?(topic)
      if (topic.category_id &&
        topic.category_id == SiteSetting.zspace_community_uploads_category_id.to_i)
        
        return !topic.archived &&
          is_my_own?(topic) &&
          !topic.edit_time_limit_expired?(user) &&
          !Post.where(topic_id: topic.id, post_number: 1).where.not(locked_by_id: nil).exists?
      end
      super
    end
  end
  
  class ::Guardian
    prepend CommunityUploadsAllowEdits
  end
end