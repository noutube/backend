import StorageObject from 'ember-local-storage/local/object';

export default class SettingsStorage extends StorageObject {
  static initialState() {
    return {
      id: null,
      email: null,
      authenticationToken: null
    };
  }
}
