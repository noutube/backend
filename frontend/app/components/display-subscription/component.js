import Ember from 'ember';

export default Ember.Component.extend({
  subscription: null,
  state: '',

  items: Ember.computed('subscription.items.@each.state', 'state', function() {
    let items = this.get('state') === 'new'   ? this.get('subscription.newItems')   :
                this.get('state') === 'later' ? this.get('subscription.laterItems') :
                                                this.get('subscription.items');
    return items;
  })
});
