import { computed, get } from '@ember/object';

import StorageObject from 'ember-local-storage/local/object';

import config from 'nou2ube/config/environment';
const {
  themes: [defaultTheme],
  videoKeys: [{ value: defaultVideoKey }],
  channelKeys: [{ value: defaultChannelKey }],
  dirs: [{ value: defaultDir }],
  defaultChannelGroup
} = config;

export default class SettingsStorage extends StorageObject {
  static initialState() {
    return {
      theme: defaultTheme,
      videoKey: defaultVideoKey,
      videoDir: defaultDir,
      channelKey: defaultChannelKey,
      channelDir: defaultDir,
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
