import { get, set } from '@ember/object';
import Service from '@ember/service';

import { storageFor } from 'ember-local-storage';

export default Service.extend({
  settings: storageFor('settings'),

  themeClass: '',

  applyTheme() {
    let oldThemeClass = get(this, 'themeClass');
    let newThemeClass = `theme--${get(this, 'settings.theme')}`;
    if (newThemeClass !== oldThemeClass) {
      if (oldThemeClass) {
        document.querySelector('body').classList.remove(oldThemeClass);
      }
      if (newThemeClass) {
        document.querySelector('body').classList.add(newThemeClass);
      }
      set(this, 'themeClass', newThemeClass);
    }
  }
});
