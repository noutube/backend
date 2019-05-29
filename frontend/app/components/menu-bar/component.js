import $ from 'jquery';
import Component from '@ember/component';
import { get, set } from '@ember/object';
import { inject as service } from '@ember/service';
import { storageFor } from 'ember-local-storage';
import config from 'frontend/config/environment';

const { themes } = config;

export default Component.extend({
  session: service(),

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
      let index = themes.indexOf(get(this, 'settings.theme'));
      set(this, 'settings.theme', themes[(index + 1) % themes.length]);
    }
  },

  onKeyUp(e) {
    if (e.keyCode === 84) {
      this.send('switchTheme');
    }
  }
});
