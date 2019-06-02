import Component from '@ember/component';
import { action, set } from '@ember/object';
import { inject as service } from '@ember/service';

export default class RoutePrivacyComponent extends Component {
  @service session;
  @service router;

  showDestroyMe = false;

  @action
  toggleDestroyMe() {
    this.toggleProperty('showDestroyMe');
  }

  @action
  async destroyMe() {
    let { me } = this.session;
    try {
      me.deleteRecord();
      await me.save();
      set(this.session, 'me', null);
      this.router.transitionTo('landing');
    } catch (e) {
      me.rollbackAttributes();
    }
  }
}
