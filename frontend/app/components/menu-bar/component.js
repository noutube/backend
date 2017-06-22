import Ember from 'ember';
import { storageFor } from 'ember-local-storage';

export default Ember.Component.extend({
  settings: storageFor('settings'),

  classNames: ['menu-bar'],

  didInsertElement() {
    Ember.$(document).on('keyup', this.onKeyUp.bind(this));
  },
  willDestroyElement() {
    Ember.$(document).off('keyup', this.onKeyUp.bind(this));
  },
  onKeyUp(e) {
    if (e.keyCode === 84) {
      this.send('switchTheme');
    }
  },

  actions: {
    switchTheme() {
      this.set('settings.theme', this.get('settings.theme') === 'light' ? 'dark' : 'light');
    }
  }
});
