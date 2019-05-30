import DS from 'ember-data';
const { Model, hasMany, attr } = DS;

export default class ChannelModel extends Model {
  @attr('string') apiId;
  @attr('string') title;
  @attr('string') thumbnail;

  @hasMany('videos') videos;
  @hasMany('subscriptions') subscriptions;
}
