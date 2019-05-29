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

  actions: {
    switchTheme() {
      let index = themes.indexOf(get(this, 'settings.theme'));
      set(this, 'settings.theme', themes[(index + 1) % themes.length]);
    }
  }
});
