import DS from 'ember-data';
const { Model, belongsTo, hasMany, attr } = DS;

export default class VideoModel extends Model {
  @attr('string') apiId;
  @attr('string') title;
  @attr('string') thumbnail;
  @attr('number') duration;
  @attr('date') publishedAt;

  @belongsTo('channel') channel;
  @hasMany('items') items;
}
