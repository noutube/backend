class Ability
  include CanCan::Ability

  def initialize(user)
    can [:read, :destroy], User, id: user.id
    can :read, Subscription, user_id: user.id
    can [:read, :update, :destroy], Item, subscription: { user_id: user.id }
  end
end
