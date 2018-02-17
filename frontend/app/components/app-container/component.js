import Component from '@ember/component';
import { storageFor } from 'ember-local-storage';

import RecognizerMixin from 'ember-gestures/mixins/recognizers';

import computed from 'ember-macro-helpers/computed';

export default Component.extend(RecognizerMixin, {
  recognizers: 'pan',

  classNames: ['container'],

  classNameBindings: ['themeClass'],

  themeClass: computed('settings.theme', function() {
    return `theme--${this.get('settings.theme')}`;
  }),

  settings: storageFor('settings')
});
