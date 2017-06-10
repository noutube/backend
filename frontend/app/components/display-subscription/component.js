import Ember from 'ember';

export default Ember.Component.extend({
  subscription: null,
  items: null,

  totalDuration: Ember.computed('items.[]', function() {
    return this.get('items').map((item) => item.get('video.duration')).reduce((acc, n) => acc + n, 0);
  }),

  isNew: Ember.computed('items.[]', function() {
    return this.get('items').any((item) => item.get('isNew'));
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
