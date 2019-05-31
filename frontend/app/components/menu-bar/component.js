import Component from '@ember/component';
import { action } from '@ember/object';
import { inject as service } from '@ember/service';

import { classNames } from '@ember-decorators/component';

export default
@classNames('menu-bar')
class MenuBarComponent extends Component {
  @service session;
  @service theme;

  @action
  switchTheme() {
    this.theme.switchTheme();
  }
}
