import DS from 'ember-data';
const { Model, hasMany, attr } = DS;

export default Model.extend({
  apiId: attr('string'),
  title: attr('string'),
  thumbnail: attr('string'),

  videos: hasMany('videos'),
  subscriptions: hasMany('subscriptions')
});
