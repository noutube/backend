import StorageObject from 'ember-local-storage/local/object';
import config from 'frontend/config/environment';

let SettingsStorage = StorageObject.extend();

const { themes: [defaultTheme], defaultVideoKey, defaultVideoDir, defaultChannelKey, defaultChannelDir, defaultChannelGroup } = config;

SettingsStorage.reopenClass({
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

export default SettingsStorage;
