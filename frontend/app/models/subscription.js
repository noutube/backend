import DS from 'ember-data';
const { Model, belongsTo, hasMany } = DS;

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

export default Model.extend({
  channel: belongsTo('channel'),
  items: hasMany('items'),

  sortableTitle: computed('channel.title', (title) => title.toLowerCase()),
  hasNew: array.isAny('items', raw('new')),
  hasLater: array.isAny('items', raw('later'))
});
