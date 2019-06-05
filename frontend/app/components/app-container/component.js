import Component from '@ember/component';
import { inject as service } from '@ember/service';

import RecognizerMixin from 'ember-gestures/mixins/recognizers';

export default class AppContainerComponent extends Component.extend(RecognizerMixin) {
  @service session;

  recognizers = 'pan';
}
