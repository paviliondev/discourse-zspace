import discourseComputed from "discourse-common/utils/decorators";
import UploadMixin from "discourse/mixins/upload";
import { bufferedProperty } from "discourse/mixins/buffered-content";

export default Ember.Component.extend(UploadMixin, bufferedProperty("buffered"), {
  classNames: ["zpace-upload"],
  type: "document",
  tagName: "span",

  @discourseComputed("uploading")
  uploadButtonText(uploading) {
    return uploading ? I18n.t("uploading") : I18n.t("upload");
  },

  validateUploadedFilesOptions() {
    return { imagesOnly: false };
  },

  uploadDone(upload) {
    if (this) {
      this.set("buffered.zspace_upload", upload);
      bootbox.alert(I18n.t("zspace.upload_successful"));
    }
  },
 

  actions: {
    removeUpload(upload) {

    var that = this;
    return bootbox.confirm(
      I18n.t("zspace.delete_upload_confirm"),
      I18n.t("no_value"),
      I18n.t("yes_value"),
      result => {
        if (result) {
                that.set("buffered.zspace_upload", null);
        }
      }
    );
  }}
});
