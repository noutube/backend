import $ from 'jquery';
import Component from '@ember/component';
import { get, set } from '@ember/object';
import { storageFor } from 'ember-local-storage';

export default Component.extend({
  classNames: ['menu-bar'],

  settings: storageFor('settings'),

  didInsertElement() {
    $(document).on('keyup', this.onKeyUp.bind(this));
  },
  willDestroyElement() {
    $(document).off('keyup', this.onKeyUp.bind(this));
  },

  actions: {
    switchTheme() {
      set(this, 'settings.theme', get(this, 'settings.theme') === 'light' ? 'dark' : 'light');
    }
  },

  onKeyUp(e) {
    if (e.keyCode === 84) {
      this.send('switchTheme');
    }
  }
});
