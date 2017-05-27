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
      this.get('items').forEach((item) => {
        item.set('state', 'state_later');
        item.save().catch(() => {
          item.rollbackAttributes();
        });
      });
    },
    destroyAll() {
      this.get('items').invoke('destroyRecord');
    }
  }
});
