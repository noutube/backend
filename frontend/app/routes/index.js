import Ember from 'ember';

export default Ember.Route.extend({
  model() {
    // fetch all data for user
    return Ember.RSVP.hash({
      items: this.get('store').findAll('item'),
      subscriptions: this.get('store').findAll('subscription')
    });
  }
});
