import $ from 'jquery';
import Component from '@ember/component';
import { get, getProperties, observer, set } from '@ember/object';

import { storageFor } from 'ember-local-storage';

import RecognizerMixin from 'ember-gestures/mixins/recognizers';

import computed from 'ember-macro-helpers/computed';

export default Component.extend(RecognizerMixin, {
  recognizers: 'pan',

  classNameBindings: ['themeClass'],

  themeClass: computed('settings.theme', (theme) => `theme--${theme}`),

  _themeClass: '',
  applyThemeClass: observer('themeClass', function() {
    let { themeClass, _themeClass } = getProperties(this, ['themeClass', '_themeClass']);
    if (themeClass !== _themeClass) {
      this.removeThemeClass();
      this.addThemeClass();
    }
  }),
  removeThemeClass() {
    $('body').removeClass(get(this, '_themeClass'));
  },
  addThemeClass() {
    let themeClass = get(this, 'themeClass');
    $('body').addClass(themeClass);
    set(this, '_themeClass', themeClass);
  },

  didInsertElement() {
    this.addThemeClass();
  },

  willDestroyElement() {
    this.removeThemeClass();
  },

  settings: storageFor('settings')
});
