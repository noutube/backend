import DS from 'ember-data';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

export default DS.Model.extend({
  channel: DS.belongsTo('channel'),
  items: DS.hasMany('items'),

  sortableTitle: computed('channel.title', (title) => title.toLowerCase()),
  hasNew: array.isAny('items', raw('new'), raw(true)),
  hasLater: array.isAny('items', raw('later'), raw(true))
});
