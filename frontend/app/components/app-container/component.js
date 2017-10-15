import Component from '@ember/component';
import { storageFor } from 'ember-local-storage';

import RecognizerMixin from 'ember-gestures/mixins/recognizers';

export default Component.extend(RecognizerMixin, {
  recognizers: 'pan',

  settings: storageFor('settings'),

  classNames: ['container'],

  classNameBindings: ['settings.theme']
});
