import StorageObject from 'ember-local-storage/local/object';

let SettingsStorage = StorageObject.extend();

SettingsStorage.reopenClass({
  initialState() {
    return {
      theme: 'light'
    };
  }
});

export default SettingsStorage;
