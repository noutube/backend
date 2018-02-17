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

    let feed = consumer.subscriptions.create('FeedChannel');
    feed.connected = () => {
      console.debug('[feed] connected');
      if (get(this, 'reconnecting')) {
        // fetch anything we missed
        get(this, 'store').unloadAll();
        this.refresh();
      }
      set(this, 'reconnecting', false);
    };
    feed.disconnected = () => {
      console.debug('[feed] disconnected');
      set(this, 'reconnecting', true);
    };
    feed.received = (data) => {
      console.debug('[feed] message', data);
      switch (data.action) {
        case 'create':
        case 'update':
          get(this, 'store').pushPayload(data.payload);
          break;
        case 'destroy': {
          let record = get(this, 'store').peekRecord(data.type, data.id);
          if (record && !get(record, 'isDeleted')) {
            record.deleteRecord();
          }
          break;
        }
      }
    };

    set(this, 'consumer', consumer);
    set(this, 'feed', feed);
  },

  deactivate() {
    if (get(this, 'consumer')) {
      get(this, 'feed').unsubscribe();
      // TODO: pending https://github.com/algonauti/ember-cable/pull/30
      // get(this, 'consumer').destroy();
      set(this, 'consumer', null);
      set(this, 'feed', null);
      set(this, 'reconnecting', false);
    }
  }
});
