import { get } from '@ember/object';
import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';

export default Route.extend({
  session: service(),

  async beforeModel(transition) {
    let me = get(this, 'session.me');
    if (me) {
      this.transitionTo('feed');
    }
  }
});
