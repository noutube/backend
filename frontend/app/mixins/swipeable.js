import { get, set } from '@ember/object';
import Mixin from '@ember/object/mixin';

import { normalizeEvent } from 'ember-jquery-legacy';
import computed from 'ember-macro-helpers/computed';

export default Mixin.create({
  // configurable properties
  swipeLimit: 50,
  swipeLeft: 'swipeLeft',
  swipeRight: 'swipeRight',

  // use to position element
  swipePosition: computed('offsetX', 'directionX', (offsetX, directionX) => offsetX * directionX),
  swipeClass: computed('isSwiping', (isSwiping) => isSwiping ? 'swiping' : ''),

  // internals

  isSwiping: false,
  deltaX: 0,
  offsetX: computed('swipeLimit', 'deltaX', (swipeLimit, deltaX) => Math.min(swipeLimit, Math.abs(deltaX))),
  directionX: computed('deltaX', (deltaX) => Math.sign(deltaX)),

  panStart(event) {
    set(this, 'isSwiping', true);
    set(this, 'deltaX', 0);
    return false;
  },
  panMove(event) {
    if (get(this, 'isSwiping')) {
      set(this, 'deltaX', normalizeEvent(event).gesture.deltaX);
      if (Math.abs(normalizeEvent(event).gesture.deltaY) > get(this, 'swipeLimit') / 2) {
        this.panCancel(event);
      }
      return false;
    }
  },
  panEnd(event) {
    set(this, 'isSwiping', false);
    if (get(this, 'offsetX') === get(this, 'swipeLimit')) {
      if (get(this, 'directionX') > 0) {
        this.send(get(this, 'swipeRight'));
      } else {
        this.send(get(this, 'swipeLeft'));
      }
    }
    set(this, 'deltaX', 0);
    return false;
  },
  panCancel(event) {
    set(this, 'isSwiping', false);
    set(this, 'deltaX', 0);
    return false;
  }
});
