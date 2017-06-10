import Ember from 'ember';

export default Ember.Component.extend({
  items: null,
  subscriptions: null,

  processSubscriptions(state) {
    return this.get('subscriptions')
      .filter((subscription) => subscription.get('items').filter((item) => item.get(state)).length > 0)
      .sort((subscriptionA, subscriptionB) => {
        let titleA = subscriptionA.get('channel.title').toLowerCase();
        let titleB = subscriptionB.get('channel.title').toLowerCase();
        return titleA.localeCompare(titleB);
      });
  },

  newSubscriptions: Ember.computed('subscriptions.[]', 'items.@each.new', function() {
    return this.processSubscriptions('new');
  }),
  laterSubscriptions: Ember.computed('subscriptions.[]', 'items.@each.later', function() {
    return this.processSubscriptions('later');
  }),
  noItems: Ember.computed('items.@each.{new,later}', function() {
    return this.get('items')
      .filter((item) => item.get('new') || item.get('later'))
      .length == 0;
  }),

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
