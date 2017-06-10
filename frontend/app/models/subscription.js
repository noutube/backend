import DS from 'ember-data';

export default DS.Model.extend({
  channel: DS.belongsTo('channel'),
  items: DS.hasMany('items')
});
