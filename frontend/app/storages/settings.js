import StorageObject from 'ember-local-storage/local/object';
import config from 'frontend/config/environment';

let SettingsStorage = StorageObject.extend();

const { themes: [defaultTheme] } = config;

SettingsStorage.reopenClass({
  initialState() {
    return {
      theme: defaultTheme
    };
  }
});

export default SettingsStorage;
