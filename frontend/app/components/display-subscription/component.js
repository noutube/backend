import { action, computed, get } from '@ember/object';
import { sort } from '@ember/object/computed';

import { classNames } from '@ember-decorators/component';

import { storageFor } from 'ember-local-storage';

import SwipeableComponent from 'frontend/components/swipeable/component';

export default
@classNames('subscription')
class DisplaySubscriptionComponent extends SwipeableComponent {
  @storageFor('settings') settings;

  subscription = null;
  state = null;

  // can't filterBy a bound key, do it manually
  @computed('subscription.items.@each.{new,later}', 'state')
  get itemsUnsorted() {
    return this.subscription.items.filterBy(this.state);
  }
  @sort('itemsUnsorted', 'settings.videoSort') items;

  @computed('items')
  get totalDuration() {
    return this.items.map((item) => get(item.video, 'duration')).reduce((acc, n) => acc + n, 0);
  }

  @action
  markAllLater() {
    this.items.invoke('markLater');
  }
  @action
  ignoreAll() {
    this.items.invoke('markDeleted');
  }

  swipeLeft() {
    this.ignoreAll();
  }
  swipeRight() {
    if (this.state === 'new') {
      this.markAllLater();
    } else {
      this.ignoreAll();
    }
  }
}
