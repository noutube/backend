import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  subscription: DS.belongsTo('subscription'),
  video: DS.belongsTo('video'),

  state: DS.attr('string'),

  isNew: Ember.computed('state', 'isDeleted', function() {
    return this.get('state') === 'state_new' && !this.get('isDeleted');
  }),
  isLater: Ember.computed('state', 'isDeleted', function() {
    return this.get('state') === 'state_later' && !this.get('isDeleted');
  }),

  markLater() {
    this.set('state', 'state_later');
    this.save().catch(() => {
      this.rollbackAttributes();
    });
  },
  markDeleted() {
    this.deleteRecord();
    this.save().catch(() => {
      this.rollbackAttributes();
    });
  }
});
