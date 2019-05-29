import StorageObject from 'ember-local-storage/local/object';

import config from 'frontend/config/environment';
const { themes: [defaultTheme], defaultVideoKey, defaultVideoDir, defaultChannelKey, defaultChannelDir, defaultChannelGroup } = config;

export default StorageObject.extend().reopenClass({
  initialState() {
    return {
      theme: defaultTheme,
      videoKey: defaultVideoKey,
      videoDir: defaultVideoDir,
      channelKey: defaultChannelKey,
      channelDir: defaultChannelDir,
      channelGroup: defaultChannelGroup
    };
  }
});
