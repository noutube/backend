import { set } from '@ember/object';
import DS from 'ember-data';
const { Model, belongsTo, attr } = DS;

import { and, eq, not } from 'ember-awesome-macros';
import raw from 'ember-macro-helpers/raw';

export default Model.extend({
  state: attr('string'),

  subscription: belongsTo('subscription'),
  video: belongsTo('video'),

  new: and(eq('state', raw('state_new')), not('isDeleted')),
  later: and(eq('state', raw('state_later')), not('isDeleted')),

  markLater() {
    set(this, 'state', 'state_later');
    this.save().catch(() => this.rollbackAttributes());
  },
  markDeleted() {
    this.deleteRecord();
    this.save().catch(() => this.rollbackAttributes());
  }
});
