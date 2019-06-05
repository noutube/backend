import { computed } from '@ember/object';
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

import { Promise, hash } from 'rsvp';

import config from 'nou2ube/config/environment';

export default class FeedRoute extends Route {
  @service cable;
  @service session;

  #consumer = null;
  #feed = null;
  #reconnecting = false;

  @computed('session.me')
  get cableAddress() {
    return `${config.backendOrigin.replace(/^http/, 'ws')}/cable/?user_email=${this.session.me.email}&user_token=${this.session.me.authenticationToken}`;
  }

  async beforeModel(transition) {
    if (!this.session.me && !this.session.down) {
      this.transitionTo('landing');
    }
  }

  model() {
    if (this.session.down) {
      // load indefinitely
      return new Promise(() => {});
    } else {
      // fetch all data for user
      return hash({
        items: this.store.findAll('item'),
        subscriptions: this.store.findAll('subscription')
      });
    }
  }

  activate() {
    if (this.session.down) {
      return;
    }

    this.#consumer = this.cable.createConsumer(this.cableAddress);

    let route = this;
    this.#feed = this.#consumer.subscriptions.create('FeedChannel', {
      connected() {
        console.debug('[feed] connected');
        if (route.#reconnecting) {
          // fetch anything we missed
          route.reloadFromServer('item');
          route.reloadFromServer('subscription');
        }
        route.#reconnecting = false;
      },
      disconnected() {
        if (!route.#reconnecting) {
          console.debug('[feed] disconnected');
          route.#reconnecting = true;
        }
      },
      received(data) {
        console.debug('[feed] message', data);
        switch (data.action) {
          case 'create':
          case 'update':
            route.store.pushPayload(data.payload);
            break;
          case 'destroy': {
            let record = route.store.peekRecord(data.type, data.id);
            if (record && !record.isDeleted) {
              record.deleteRecord();
            }
            break;
          }
        }
      }
    });
  }

  deactivate() {
    if (this.#consumer) {
      this.#consumer.destroy();
      this.#consumer = null;
      this.#feed.unsubscribe();
      this.#feed = null;
      this.#reconnecting = false;
      console.debug('[feed] destroyed');
    }

    this.store.unloadAll('item');
    this.store.unloadAll('subscription');
  }

  async reloadFromServer(modelName) {
    let before = this.store.peekAll(modelName);
    let after = await this.store.query(modelName, {});
    // manually remove anything removed on server
    before
      .filter((model) => !after.findBy('id', model.id))
      .forEach((model) => model.deleteRecord());
  }
}
