import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default class ApplicationRoute extends Route {
  @service session;
  @service theme;

  async beforeModel(transition) {
    this.theme.applyTheme();

    try {
      this.session.me = await this.store.queryRecord('user', { me: true });
    } catch (e) {
      // not logged in, swallow
    }
  }
}
