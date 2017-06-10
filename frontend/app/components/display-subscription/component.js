import Ember from 'ember';

export default Ember.Component.extend({
  subscription: null,
  state: null,

  items: Ember.computed('state', 'subscription.items.@each.{new,later}', function() {
    return this.get('subscription.items')
      .filter((item) => item.get(this.get('state')))
      .sort((itemA, itemB) => itemB.get('video.publishedAt') - itemA.get('video.publishedAt'));
  }),

  totalDuration: Ember.computed('items.[]', function() {
    return this.get('items')
      .map((item) => item.get('video.duration'))
      .reduce((acc, n) => acc + n, 0);
  }),

  actions: {
    markAllLater() {
      this.get('items').invoke('markLater');
    },
    destroyAll() {
      this.get('items').invoke('markDeleted');
    }
  }
});
