import { action, computed, get } from '@ember/object';

import { classNames } from '@ember-decorators/component';

import { storageFor } from 'ember-local-storage';

import SwipeableComponent from 'frontend/components/swipeable/component';

export default
@classNames('item')
class DisplayItemComponent extends SwipeableComponent {
  @storageFor('settings') settings;

  item = null;
  embed = false;

  @computed('item.video.duration')
  get formattedDuration() {
    let duration = get(this.item.video, 'duration');
    let result = `${(`00${Math.floor(duration / 60) % 60}`).slice(-2)}:${(`00${duration % 60}`).slice(-2)}`;
    if (duration >= 60 * 60) {
      result = `${Math.floor(duration / 60 / 60)}:${result}`;
    }
    return result;
  }

  @action
  markLater() {
    this.item.markLater();
  }
  @action
  markWatched() {
    this.item.markDeleted();
  }
  @action
  toggleEmbed() {
    this.toggleProperty('embed');
  }

  swipeLeft() {
    this.markWatched();
  }
  swipeRight() {
    if (this.item.state === 'state_new') {
      this.markLater();
    } else {
      this.markWatched();
    }
  }
}
