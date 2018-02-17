import Ember from 'ember';
import StorageObject from 'ember-local-storage/local/object';

let SettingsStorage = StorageObject.extend();

const { ENV: { themes: [defaultTheme] } } = Ember;

SettingsStorage.reopenClass({
  initialState() {
    return {
      theme: defaultTheme
    };
  }
});

export default SettingsStorage;
