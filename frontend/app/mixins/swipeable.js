import Mixin from '@ember/object/mixin';

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
    this.set('isSwiping', true);
    this.set('deltaX', 0);
    return false;
  },
  panMove(event) {
    if (this.get('isSwiping')) {
      this.set('deltaX', event.originalEvent.gesture.deltaX);
      if (Math.abs(event.originalEvent.gesture.deltaY) > this.get('swipeLimit') / 2) {
        this.panCancel(event);
      }
      return false;
    }
  },
  panEnd(event) {
    this.set('isSwiping', false);
    if (this.get('offsetX') === this.get('swipeLimit')) {
      if (this.get('directionX') > 0) {
        this.send(this.get('swipeRight'));
      } else {
        this.send(this.get('swipeLeft'));
      }
    }
    this.set('deltaX', 0);
    return false;
  },
  panCancel(event) {
    this.set('isSwiping', false);
    this.set('deltaX', 0);
    return false;
  }
});
