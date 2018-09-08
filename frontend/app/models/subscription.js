import { get } from '@ember/object';
import { alias } from '@ember/object/computed';
import DS from 'ember-data';
const { Model, belongsTo, hasMany } = DS;

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

export default Model.extend({
  channel: belongsTo('channel'),
  items: hasMany('items'),

  hasNew: array.isAny('items', raw('new')),
  hasLater: array.isAny('items', raw('later')),

  sortableTitle: computed('channel.title', (title) => title.toLowerCase()),
  totalDuration: array.reduce(array.map('items', (item) => get(item, 'video.duration')), (acc, n) => acc + n, 0),
  itemCount: alias('items.length')
});
