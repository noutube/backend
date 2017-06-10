import Ember from 'ember';

export default Ember.Component.extend({
  items: null,
  subscriptions: null,

  didInsertElement() {
    Ember.$(document).on('keyup', this.onKeyUp.bind(this));
  },
  willDestroyElement() {
    Ember.$(document).off('keyup', this.onKeyUp.bind(this));
  },
  onKeyUp(e) {
    if (e.keyCode === 82) {
      this.send('refresh');
    }
  },

  actions: {
    refresh() {
      this.attrs.refresh();
    }
  }
});
