import { computed } from '@ember/object';
import { inject as service } from '@ember/service';

import DS from 'ember-data';
const { JSONAPIAdapter } = DS;

import config from 'nou2ube/config/environment';

export default class ApplicationAdapter extends JSONAPIAdapter {
  @service session;

  host = config.backendOrigin;

  @computed('session.me')
  get headers() {
    return {
      ...this.session.me && {
        'X-User-Email': this.session.me.email,
        'X-User-Token': this.session.me.authenticationToken
      }
    };
  }
}
