import DS from 'ember-data';

import { and, eq, not } from 'ember-awesome-macros';
import raw from 'ember-macro-helpers/raw';

export default DS.Model.extend({
  subscription: DS.belongsTo('subscription'),
  video: DS.belongsTo('video'),

  state: DS.attr('string'),

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
