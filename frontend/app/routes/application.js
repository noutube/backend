import { get, set } from '@ember/object';
import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';

export default Route.extend({
  session: service(),
  theme: service(),

  async beforeModel(transition) {
    let theme = get(this, 'theme');
    theme.applyTheme();

    try {
      let store = get(this, 'store');
      let me = await store.findRecord('user', 'me');
      set(this, 'session.me', me);
    } catch (e) {
      // not logged in, swallow
    }
  }
});
