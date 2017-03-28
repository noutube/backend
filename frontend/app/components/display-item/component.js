import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['item'],

  item: null,

  actions: {
    markLater() {
      this.get('item').set('state', 'state_later');
      this.get('item').save().catch(() => {
        this.get('item').rollbackAttributes();
      });
    },
    destroy() {
      this.get('item').destroyRecord();
    }
  }
});
