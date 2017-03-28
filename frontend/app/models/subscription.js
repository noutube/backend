import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  channel: DS.belongsTo('channel'),
  items: DS.hasMany('items'),

  newItems: Ember.computed('items.@each.state', function() {
    return DS.PromiseArray.create({
      promise: this.get('items').then(items => items.filter(item => item.get('isNew')))
    });
  }),
  laterItems: Ember.computed('items.@each.state', function() {
    return DS.PromiseArray.create({
      promise: this.get('items').then(items => items.filter(item => !item.get('isNew')))
    });
  })
});
