import Component from '@ember/component';
import { action, set } from '@ember/object';
import { alias, oneWay } from '@ember/object/computed';

import { classNames } from '@ember-decorators/component';

import { storageFor } from 'ember-local-storage';

import config from 'nou2ube/config/environment';

const {
  videoKeys,
  channelKeys,
  dirs
} = config;

export default
@classNames('sorting-settings')
class SortingSettingsComponent extends Component {
  @storageFor('settings') settings;

  videoKeys = videoKeys;
  channelKeys = channelKeys;
  dirs = dirs;

  @oneWay('settings.videoKey') videoKey;
  @oneWay('settings.videoDir') videoDir;
  @oneWay('settings.channelKey') channelKey;
  @oneWay('settings.channelDir') channelDir;
  @alias('settings.channelGroup') channelGroup;

  @action
  selectVideoKey(videoKey) {
    set(this, 'settings.videoKey', videoKey);
  }
  @action
  selectVideoDir(videoDir) {
    set(this, 'settings.videoDir', videoDir);
  }
  @action
  selectChannelKey(channelKey) {
    set(this, 'settings.channelKey', channelKey);
  }
  @action
  selectChannelDir(channelDir) {
    set(this, 'settings.channelDir', channelDir);
  }
}
