import Ember from 'ember';
import { storageFor } from 'ember-local-storage';

export default Ember.Component.extend({
  settings: storageFor('settings'),

  classNames: ['menu-bar'],

  actions: {
    switchTheme() {
      this.set('settings.theme', this.get('settings.theme') === 'light' ? 'dark' : 'light');
    }
  }
});
