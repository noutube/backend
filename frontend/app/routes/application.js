import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default class ApplicationRoute extends Route {
  @service session;
  @service theme;

  async beforeModel(transition) {
    this.theme.applyTheme();
    await this.session.restore();
  }
}
