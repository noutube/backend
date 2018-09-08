import { hash } from 'rsvp';
import { get, set } from '@ember/object';
import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';

export default Route.extend({
  cable: service(),

  consumer: null,
  feed: null,
  reconnecting: false,

  model() {
    // fetch all data for user
    return hash({
      items: get(this, 'store').findAll('item'),
      subscriptions: get(this, 'store').findAll('subscription')
    });
  },

  activate() {
    let consumer = get(this, 'cable').createConsumer(`${location.protocol === 'https:' ? 'wss:' : 'ws:'}//${location.host}/cable`);

    let store = get(this, 'store');
    let route = this;
    let feed = consumer.subscriptions.create('FeedChannel', {
      connected() {
        console.debug('[feed] connected');
        if (get(route, 'reconnecting')) {
          // fetch anything we missed
          store.unloadAll();
          route.refresh();
        }
        set(route, 'reconnecting', false);
      },
      disconnected() {
        console.debug('[feed] disconnected');
        set(route, 'reconnecting', true);
      },
      received(data) {
        console.debug('[feed] message', data);
        switch (data.action) {
          case 'create':
          case 'update':
            store.pushPayload(data.payload);
            break;
          case 'destroy': {
            let record = store.peekRecord(data.type, data.id);
            if (record && !get(record, 'isDeleted')) {
              record.deleteRecord();
            }
            break;
          }
        }
      }
    });

    set(this, 'consumer', consumer);
    set(this, 'feed', feed);
  },

  deactivate() {
    if (get(this, 'consumer')) {
      get(this, 'feed').unsubscribe();
      get(this, 'consumer').destroy();
      set(this, 'consumer', null);
      set(this, 'feed', null);
      set(this, 'reconnecting', false);
    }
  }
});
