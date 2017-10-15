import $ from 'jquery';
import Component from '@ember/component';
import { storageFor } from 'ember-local-storage';

export default Component.extend({
  settings: storageFor('settings'),

  classNames: ['menu-bar'],

  didInsertElement() {
    $(document).on('keyup', this.onKeyUp.bind(this));
  },
  willDestroyElement() {
    $(document).off('keyup', this.onKeyUp.bind(this));
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
