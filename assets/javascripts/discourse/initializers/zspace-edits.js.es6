import Composer from 'discourse/models/composer';
import { default as computed, observes } from 'ember-addons/ember-computed-decorators';

export default {
  name: 'zspace-edits',
  initialize() {
    Composer.serializeToTopic('zspace_upload', 'topic.custom_fields.zspace_upload');
  }
}