import $ from 'jquery';
import { get, observer } from '@ember/object';
import Component from '@ember/component';

import computed from 'ember-macro-helpers/computed';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Component.extend(SwipeableMixin, {
  classNames: ['item'],

  classNameBindings: ['swipeClass'],

  item: null,
  embed: false,
  swipeLeft: 'destroy',
  swipeRight: computed('item.state', (state) => state === 'state_new' ? 'markLater' : 'destroy'),

  swipePositionObserver: observer('deltaX', function() {
    $(this.element).css('left', get(this, 'swipePosition'));
  }),

  actions: {
    markLater() {
      get(this, 'item').markLater();
    },
    destroy() {
      get(this, 'item').markDeleted();
    },
    toggleEmbed() {
      this.toggleProperty('embed');
    }
  }
});
