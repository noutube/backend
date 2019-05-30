import { computed, get } from '@ember/object';

import StorageObject from 'ember-local-storage/local/object';

import config from 'frontend/config/environment';
const { themes: [defaultTheme], defaultVideoKey, defaultVideoDir, defaultChannelKey, defaultChannelDir, defaultChannelGroup } = config;

export default class SettingsStorage extends StorageObject {
  static initialState() {
    return {
      theme: defaultTheme,
      videoKey: defaultVideoKey,
      videoDir: defaultVideoDir,
      channelKey: defaultChannelKey,
      channelDir: defaultChannelDir,
      channelGroup: defaultChannelGroup
    };
  }

  @computed('channelKey', 'channelDir')
  get channelSort() {
    return [`${get(this, 'channelKey')}:${get(this, 'channelDir')}`];
  }

  @computed('videoKey', 'videoDir')
  get videoSort() {
    return [`${get(this, 'videoKey')}:${get(this, 'videoDir')}`];
  }

}
