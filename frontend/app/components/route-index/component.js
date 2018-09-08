import Component from '@ember/component';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

import { storageFor } from 'ember-local-storage';

export default Component.extend({
  settings: storageFor('settings'),

  items: null,
  subscriptions: null,

  channelSort: computed('settings.{channelKey,channelDir}', (key, dir) => [`${key}:${dir}`]),
  videoSort: computed('settings.{videoKey,videoDir}', (key, dir) => [`${key}:${dir}`]),

  newSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasNew')), 'channelSort'),
  laterSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasLater')), 'channelSort'),
  newItems: array.sort(array.filterBy('items', raw('new')), 'videoSort'),
  laterItems: array.sort(array.filterBy('items', raw('later')), 'videoSort'),
  anyItems: array.isAny('items', raw('isDeleted'), false),

  titleNotification: computed(array.filterBy('items', raw('new')), (newItems) => newItems.length > 0 ? `(${newItems.length})` : ''),

  showSorting: false,

  actions: {
    toggleSorting() {
      this.toggleProperty('showSorting');
    }
  }
});
