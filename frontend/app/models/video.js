import DS from 'ember-data';

export default DS.Model.extend({
  channel: DS.belongsTo('channel'),
  items: DS.hasMany('items'),

  apiId: DS.attr('string'),
  title: DS.attr('string'),
  thumbnail: DS.attr('string'),
  duration: DS.attr('number'),
  publishedAt: DS.attr('date')
});
