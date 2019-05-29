import Component from '@ember/component';
import { get } from '@ember/object';
import { htmlSafe } from '@ember/template';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';

import { storageFor } from 'ember-local-storage';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Component.extend(SwipeableMixin, {
  settings: storageFor('settings'),

  classNames: ['subscription'],

  classNameBindings: ['swipeClass'],

  attributeBindings: ['style'],
  style: computed('swipePosition', (swipePosition) => htmlSafe(`left: ${swipePosition}px;`)),

  videoSort: computed('settings.{videoKey,videoDir}', (key, dir) => [`${key}:${dir}`]),

  subscription: null,
  state: null,
  swipeLeft: 'destroyAll',
  swipeRight: computed('state', (state) => state === 'new' ? 'markAllLater' : 'destroyAll'),
  items: array.sort(array.filterBy('subscription.items', 'state'), 'videoSort'),
  totalDuration: array.reduce(array.map('items', (item) => get(item, 'video.duration')), (acc, n) => acc + n, 0),

  actions: {
    markAllLater() {
      get(this, 'items').invoke('markLater');
    },
    destroyAll() {
      get(this, 'items').invoke('markDeleted');
    }
  }
});
