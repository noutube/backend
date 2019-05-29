import { set } from '@ember/object';
import { alias } from '@ember/object/computed';

import DS from 'ember-data';
const { Model, belongsTo, attr } = DS;

import { and, eq, not } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

export default Model.extend({
  state: attr('string'),

  subscription: belongsTo('subscription'),
  video: belongsTo('video'),

  new: and(eq('state', raw('state_new')), not('isDeleted')),
  later: and(eq('state', raw('state_later')), not('isDeleted')),

  age: computed('video.publishedAt', (publishedAt) => Date.now() - publishedAt.getTime()),
  sortableTitle: computed('video.title', (title) => title.toLowerCase()),
  duration: alias('video.duration'),

  markLater() {
    set(this, 'state', 'state_later');
    this.save().catch(() => this.rollbackAttributes());
  },
  markDeleted() {
    this.deleteRecord();
    this.save().catch(() => this.rollbackAttributes());
  }
});
