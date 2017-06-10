import Ember from 'ember';

import { array } from 'ember-awesome-macros';

export default Ember.Component.extend({
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
  }
});
