import { action, getProperties, set, setProperties } from '@ember/object';
import Service, { inject as service } from '@ember/service';

import { storageFor } from 'ember-local-storage';

import config from 'nou2ube/config/environment';

export default class SessionService extends Service {
  @service store;
  @service router;

  @storageFor('session') session;

  me = null;
  #popup = null;

  init() {
    window.addEventListener('message', this.authMessage);
  }

  async restore() {
    if (!this.session.isInitialContent()) {
      try {
        let me = this.store.createRecord('user', getProperties(this.session, ['id', 'email', 'authenticationToken']));
        set(this, 'me', me);
        await me.reload();
        this.persist();
        console.debug('[session] restored');
      } catch (e) {
        console.warn('[session] restore failed', e);
        this.clear();
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
        this.store.pushPayload(payload);
        let me = this.store.peekRecord('user', payload.data.id);
        set(this, 'me', me);
        this.persist();
        console.debug('[session] signed in');
        this.router.transitionTo('feed');
      } catch (e) {
        console.warn('[session] sign in failed', e);
      }
    }
  }

  @action
  signOut() {
    this.clear();
    console.debug('[session] signed out');
    this.router.transitionTo('landing');
  }

  @action
  async destroyMe() {
    try {
      this.me.deleteRecord();
      await this.me.save();
      console.debug('[session] user destroyed');
      this.signOut();
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
