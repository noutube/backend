import Ember from 'ember';

export default Ember.Component.extend({
  subscriptions: null,
  items: null,
  state: null,

  realSubscriptions: Ember.computed('subscriptions.[]', 'items.@each.{new,later}', function() {
    return this.get('subscriptions').toArray()
      .filter((subscription) => subscription.get('items').filter((item) => item.get(this.get('state'))).length > 0)
      .sort((subscriptionA, subscriptionB) => {
        let titleA = subscriptionA.get('channel.title').toLowerCase();
        let titleB = subscriptionB.get('channel.title').toLowerCase();
        return titleA.localeCompare(titleB);
      });
  })
});
