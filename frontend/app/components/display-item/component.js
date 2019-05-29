import { get } from '@ember/object';
import Component from '@ember/component';
import { htmlSafe } from '@ember/template';

import computed from 'ember-macro-helpers/computed';

import SwipeableMixin from 'frontend/mixins/swipeable';

export default Component.extend(SwipeableMixin, {
  classNames: ['item'],

  classNameBindings: ['swipeClass'],

  attributeBindings: ['style'],
  style: computed('swipePosition', (swipePosition) => htmlSafe(`left: ${swipePosition}px;`)),

  item: null,
  embed: false,
  swipeLeft: 'destroy',
  swipeRight: computed('item.state', (state) => state === 'state_new' ? 'markLater' : 'destroy'),

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
