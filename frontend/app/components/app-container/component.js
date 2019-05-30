import Component from '@ember/component';

import RecognizerMixin from 'ember-gestures/mixins/recognizers';

export default class AppContainerComponent extends Component.extend(RecognizerMixin) {
  recognizers = 'pan';
}
