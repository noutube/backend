import $ from 'jquery';
import { get, observer } from '@ember/object';
import Component from '@ember/component';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';

import { storageFor } from 'ember-local-storage';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Component.extend(SwipeableMixin, {
  settings: storageFor('settings'),

  classNames: ['subscription'],

  classNameBindings: ['swipeClass'],

  videoSort: computed('settings.{videoKey,videoDir}', (key, dir) => [`${key}:${dir}`]),

  subscription: null,
  state: null,
  swipeLeft: 'destroyAll',
  swipeRight: computed('state', (state) => state === 'new' ? 'markAllLater' : 'destroyAll'),
  items: array.sort(array.filterBy('subscription.items', 'state'), 'videoSort'),
  totalDuration: array.reduce(array.map('items', (item) => get(item, 'video.duration')), (acc, n) => acc + n, 0),

  swipePositionObserver: observer('deltaX', function() {
    $(this.element).css('left', get(this, 'swipePosition'));
  }),

  actions: {
    markAllLater() {
      get(this, 'items').invoke('markLater');
    },
    destroyAll() {
      get(this, 'items').invoke('markDeleted');
    }
  }
});
