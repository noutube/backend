import { get } from '@ember/object';
import Route from '@ember/routing/route';
import { inject as service } from '@ember/service';

export default Route.extend({
  session: service(),

  async beforeModel(transition) {
    let me = get(this, 'session.me');
    if (me) {
      this.transitionTo('feed');
    } else {
      this.transitionTo('landing');
    }
  }
});
