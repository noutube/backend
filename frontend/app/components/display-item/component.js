import Ember from 'ember';

export default Ember.Component.extend({
  classNames: ['item'],

  item: null,
  embed: false,

  actions: {
    markLater() {
      this.get('item').markLater();
    },
    destroy() {
      this.get('item').markDeleted();
    },
    toggleEmbed() {
      this.toggleProperty('embed');
    }
  }
});
