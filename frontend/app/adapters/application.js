import CSRFAdapter from 'ember-cli-rails-addon/mixins/csrf-adapter';
import DS from 'ember-data';
const { JSONAPIAdapter } = DS;

export default JSONAPIAdapter.extend(CSRFAdapter);
