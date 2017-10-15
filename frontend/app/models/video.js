import DS from 'ember-data';
const { Model, belongsTo, hasMany, attr } = DS;

export default Model.extend({
  channel: belongsTo('channel'),
  items: hasMany('items'),

  apiId: attr('string'),
  title: attr('string'),
  thumbnail: attr('string'),
  duration: attr('number'),
  publishedAt: attr('date')
});
