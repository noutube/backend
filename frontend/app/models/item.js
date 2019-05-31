import { get, set } from '@ember/object';
import { computed } from '@ember/object';
import { alias } from '@ember/object/computed';

import DS from 'ember-data';
const { Model, belongsTo, attr } = DS;

export default class ItemModel extends Model {
  @attr('string') state;

  @belongsTo('subscription') subscription;
  @belongsTo('video') video;

  @computed('state', 'isDeleted')
  get new() {
    return this.state === 'state_new' && !this.isDeleted;
  }

  @computed('state', 'isDeleted')
  get later() {
    return this.state === 'state_later' && !this.isDeleted;
  }

  @computed('video.publishedAt')
  get age() {
    return Date.now() - this.video.publishedAt.getTime();
  }

  @computed('video.title')
  get sortableTitle() {
    return get(this.video, 'title').toLowerCase();
  }

  @alias('video.duration') duration;

  markLater() {
    set(this, 'state', 'state_later');
    this.save().catch(() => this.rollbackAttributes());
  }
  markDeleted() {
    this.deleteRecord();
    this.save().catch(() => this.rollbackAttributes());
  }
}
