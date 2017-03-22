import DS from 'ember-data';

export default DS.Model.extend({
  subscription: DS.belongsTo('subscription'),
  video: DS.belongsTo('video'),

  state: DS.attr('string')
});
