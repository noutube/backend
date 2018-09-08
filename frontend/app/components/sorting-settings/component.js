import Component from '@ember/component';
import { set } from '@ember/object';
import { alias, oneWay } from '@ember/object/computed';

import { storageFor } from 'ember-local-storage';

export default Component.extend({
  settings: storageFor('settings'),

  videoKey: oneWay('settings.videoKey'),
  videoDir: oneWay('settings.videoDir'),
  channelKey: oneWay('settings.channelKey'),
  channelDir: oneWay('settings.channelDir'),
  channelGroup: alias('settings.channelGroup'),

  actions: {
    selectVideoKey(videoKey) {
      set(this, 'settings.videoKey', videoKey);
    },
    selectVideoDir(videoDir) {
      set(this, 'settings.videoDir', videoDir);
    },
    selectChannelKey(channelKey) {
      set(this, 'settings.channelKey', channelKey);
    },
    selectChannelDir(channelDir) {
      set(this, 'settings.channelDir', channelDir);
    }
  }
});
