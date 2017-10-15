import DS from 'ember-data';
const { Model, hasMany, attr } = DS;

export default Model.extend({
  videos: hasMany('videos'),
  subscriptions: hasMany('subscriptions'),

  apiId: attr('string'),
  title: attr('string'),
  thumbnail: attr('string')
});
