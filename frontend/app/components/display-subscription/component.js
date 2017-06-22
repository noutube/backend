import Ember from 'ember';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Ember.Component.extend(SwipeableMixin, {
  classNames: ['subscription'],

  classNameBindings: ['swipeClass'],

  subscription: null,
  state: null,

  items: array.filterBy('subscription.items', 'state', true),
  totalDuration: array.reduce(array.map('items', (item) => item.get('video.duration')), (acc, n) => acc + n, 0),

  actions: {
    markAllLater() {
      this.get('items').invoke('markLater');
    },
    destroyAll() {
      this.get('items').invoke('markDeleted');
    }
  },

  swipeLeft: 'destroyAll',
  swipeRight: computed('state', (state) => state === 'new' ? 'markAllLater' : 'destroyAll'),
  swipePositionObserver: Ember.observer('deltaX', function() {
    Ember.$(this.element).css('left', this.get('swipePosition'));
  })
});
