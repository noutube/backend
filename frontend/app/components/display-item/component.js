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

  formattedDuration: computed('item.video.duration', (duration) => {
    let result = `${(`00${Math.floor(duration / 60) % 60}`).slice(-2)}:${(`00${duration % 60}`).slice(-2)}`;
    if (duration >= 60 * 60) {
      result = `${Math.floor(duration / 60 / 60)}:${result}`;
    }
    return result;
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
