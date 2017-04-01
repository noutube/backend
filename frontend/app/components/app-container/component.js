import Ember from 'ember';
import { storageFor } from 'ember-local-storage';

export default Ember.Component.extend({
  settings: storageFor('settings'),

  classNames: ['container'],

  classNameBindings: ['themeClass'],

  themeClass: Ember.computed('settings.theme', function() {
    return this.get('settings.theme');
  }),
});
