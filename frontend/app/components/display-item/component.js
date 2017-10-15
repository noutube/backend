import $ from 'jquery';
import { observer } from '@ember/object';
import Component from '@ember/component';

import computed from 'ember-macro-helpers/computed';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Component.extend(SwipeableMixin, {
  classNames: ['item'],

  classNameBindings: ['swipeClass'],

  item: null,
  embed: false,

  actions: {
    markLater() {
      this.get('item').markLater();
    },
    destroy() {
      this.get('item').markDeleted();
    },
    toggleEmbed() {
      this.toggleProperty('embed');
    }
  },

  swipeLeft: 'destroy',
  swipeRight: computed('item.state', (state) => state === 'state_new' ? 'markLater' : 'destroy'),
  swipePositionObserver: observer('deltaX', function() {
    $(this.element).css('left', this.get('swipePosition'));
  })
});
