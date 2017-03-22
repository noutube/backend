import DS from 'ember-data';

export default DS.Model.extend({
  videos: DS.hasMany('videos'),
  subscriptions: DS.hasMany('subscriptions'),

  apiId: DS.attr('string'),
  title: DS.attr('string'),
  thumbnail: DS.attr('string')
});
