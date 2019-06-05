import { action, get, getProperties, set, setProperties } from '@ember/object';
import Service, { inject as service } from '@ember/service';

import { storageFor } from 'ember-local-storage';

import config from 'nou2ube/config/environment';

export default class SessionService extends Service {
  @service store;
  @service router;

  @storageFor('session') session;

  me = null;
  down = false;
  #popup = null;

  init() {
    window.addEventListener('message', this.authMessage);
  }

  async restore() {
    if (!this.session.isInitialContent()) {
      try {
        let response = await fetch(`${config.backendOrigin}/auth/restore`, {
          headers: {
            'X-User-Email': get(this.session, 'email'),
            'X-User-Token': get(this.session, 'authenticationToken')
          }
        });
        if (response.status > 500) {
          throw response.status;
        } else if (response.ok) {
          let payload = await response.json();
          this.pushMe(payload);
          console.debug('[session] restored');
        } else {
          console.warn('[session] restore failed: rejected', response.status);
          this.clear();
        }
      } catch (e) {
        console.warn('[session] restore failed: down', e);
        set(this, 'down', true);
      }
    }
  }

  @action
  signIn() {
    this.closePopup();
    this.#popup = window.open(`${config.backendOrigin}/auth`);
  }

  @action
  async authMessage(event) {
    if (event.origin !== config.backendOrigin) {
      return;
    }

    if (event.data.name === 'login') {
      this.closePopup();
      try {
        let response = await fetch(`${config.backendOrigin}/auth/sign_in?code=${event.data.data.code}`);
        let payload = await response.json();
        this.pushMe(payload);
        console.debug('[session] signed in');
        this.router.transitionTo('feed');
      } catch (e) {
        console.warn('[session] sign in failed', e);
      }
    }
  }

  pushMe(payload) {
    this.store.pushPayload(payload);
    let me = this.store.peekRecord('user', payload.data.id);
    set(this, 'me', me);
    this.persist();
  }

  @action
  signOut() {
    console.debug('[session] signed out');
    this.clear();
  }

  @action
  async destroyMe() {
    try {
      this.me.deleteRecord();
      await this.me.save();
      console.debug('[session] user destroyed');
      this.clear();
    } catch (e) {
      console.warn('[session] user destroy failed', e);
      this.me.rollbackAttributes();
    }
  }

  clear() {
    if (this.me) {
      this.me.unloadRecord();
      set(this, 'me', null);
    }
    this.persist();
    this.router.transitionTo('landing');
  }

  persist() {
    if (this.me) {
      setProperties(this.session, getProperties(this.me, ['id', 'email', 'authenticationToken']));
    } else {
      this.session.reset();
    }
  }

  closePopup() {
    if (this.#popup) {
      this.#popup.close();
      this.#popup = null;
    }
  }
}
