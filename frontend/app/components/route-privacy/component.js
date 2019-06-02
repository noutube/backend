import Component from '@ember/component';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

export default class RoutePrivacyComponent extends Component {
  @service session;

  showDestroyMe = false;

  @action
  toggleDestroyMe() {
    this.toggleProperty('showDestroyMe');
  }
}
