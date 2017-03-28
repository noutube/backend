import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  subscription: DS.belongsTo('subscription'),
  video: DS.belongsTo('video'),

  state: DS.attr('string'),

  isNew: Ember.computed('state', function() {
    return this.get('state') === 'state_new';
  })
});
