import DS from 'ember-data';
const { Model, belongsTo, attr } = DS;

import { and, eq, not } from 'ember-awesome-macros';
import raw from 'ember-macro-helpers/raw';

export default Model.extend({
  subscription: belongsTo('subscription'),
  video: belongsTo('video'),

  state: attr('string'),

  new: and(eq('state', raw('state_new')), not('isDeleted')),
  later: and(eq('state', raw('state_later')), not('isDeleted')),

  markLater() {
    this.set('state', 'state_later');
    this.save().catch(() => {
      this.rollbackAttributes();
    });
  },
  markDeleted() {
    this.deleteRecord();
    this.save().catch(() => {
      this.rollbackAttributes();
    });
  }
});
