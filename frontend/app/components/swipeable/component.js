import Component from '@ember/component';
import { computed, set } from '@ember/object';
import { htmlSafe } from '@ember/template';

import { attribute, className } from '@ember-decorators/component';

export default class SwipeableComponent extends Component {
  // configurable properties
  swipeLimit = 50;
  swipeLeft() {
  }
  swipeRight() {
  }

  // use to position element
  @computed('offsetX', 'directionX')
  get swipePosition() {
    return this.offsetX * this.directionX;
  }
  @className
  @computed('isSwiping')
  get swipeClass() {
    return this.isSwiping ? 'swiping' : '';
  }
  @attribute
  @computed('swipePosition')
  get style() {
    return htmlSafe(`left: ${this.swipePosition}px;`);
  }

  // internals

  isSwiping = false;
  deltaX = 0;
  @computed('swipeLimit', 'deltaX')
  get offsetX() {
    return Math.min(this.swipeLimit, Math.abs(this.deltaX));
  }
  @computed('deltaX')
  get directionX() {
    return Math.sign(this.deltaX);
  }

  panStart(event) {
    set(this, 'isSwiping', true);
    set(this, 'deltaX', 0);
    return false;
  }
  panMove(event) {
    if (this.isSwiping) {
      set(this, 'deltaX', event.gesture.deltaX);
      if (Math.abs(event.gesture.deltaY) > this.swipeLimit / 2) {
        this.panCancel(event);
      }
      return false;
    }
  }
  panEnd(event) {
    set(this, 'isSwiping', false);
    if (this.offsetX === this.swipeLimit) {
      if (this.directionX > 0) {
        this.swipeRight();
      } else {
        this.swipeLeft();
      }
    }
    set(this, 'deltaX', 0);
    return false;
  }
  panCancel(event) {
    set(this, 'isSwiping', false);
    set(this, 'deltaX', 0);
    return false;
  }
}
