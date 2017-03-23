import Ember from 'ember';
import DS from 'ember-data';

export default Ember.Component.extend({
  items: null,
  subscriptions: null,

  newSubscriptions: Ember.computed('subscriptions.[]', function() {
    return DS.PromiseArray.create({
      promise: Ember.RSVP.filter(this.get('subscriptions').toArray(), subscription => subscription.get('newItems').then(items => items.length > 0))
    });
  }),
  laterSubscriptions: Ember.computed('subscriptions.[]', function() {
    return DS.PromiseArray.create({
      promise: Ember.RSVP.filter(this.get('subscriptions').toArray(), subscription => subscription.get('laterItems').then(items => items.length > 0))
    });
  })
});
