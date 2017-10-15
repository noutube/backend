import Component from '@ember/component';

import { array } from 'ember-awesome-macros';
import computed from 'ember-macro-helpers/computed';
import raw from 'ember-macro-helpers/raw';

export default Component.extend({
  items: null,
  subscriptions: null,

  newSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasNew')), ['sortableTitle']),
  laterSubscriptions: array.sort(array.filterBy('subscriptions', raw('hasLater')), ['sortableTitle']),
  anyItems: array.isAny('items', raw('isDeleted'), false),

  titleNotification: computed(array.filterBy('items', raw('new')), (newItems) => newItems.length > 0 ? `(${newItems.length})` : '')
});
