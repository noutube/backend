import DS from 'ember-data';
const { JSONAPIAdapter } = DS;

import CSRFAdapter from 'ember-cli-rails-addon/mixins/csrf-adapter';

export default JSONAPIAdapter.extend(CSRFAdapter, {
  queryRecord(store, type, query) {
    if (type.modelName === 'user' && query && query.me) {
      // special case finding current user
      let url = this.buildURL(type.modelName, 'me', null, 'findRecord');
      return this.ajax(url, 'GET');
    } else {
      return this._super(...arguments);
    }
  }
});
