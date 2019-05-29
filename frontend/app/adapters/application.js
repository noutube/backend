import DS from 'ember-data';
const { JSONAPIAdapter } = DS;

import CSRFAdapter from 'ember-cli-rails-addon/mixins/csrf-adapter';

export default JSONAPIAdapter.extend(CSRFAdapter);
