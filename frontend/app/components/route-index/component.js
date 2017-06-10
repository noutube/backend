import Ember from 'ember';

import { array } from 'ember-awesome-macros';
import raw from 'ember-macro-helpers/raw';

export default Ember.Component.extend({
  items: null,
  subscriptions: null,

  newSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasNew'), true), ['sortableTitle']),
  laterSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasLater'), true), ['sortableTitle']),
  anyItems: array.isAny('items', raw('isDeleted'), false),

  didInsertElement() {
    Ember.$(document).on('keyup', this.onKeyUp.bind(this));
  },
  willDestroyElement() {
    Ember.$(document).off('keyup', this.onKeyUp.bind(this));
  },
  onKeyUp(e) {
    if (e.keyCode === 82) {
      this.send('refresh');
    }
  },

  actions: {
    refresh() {
      this.attrs.refresh();
    }
  }
});
