class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    else
      can [:read, :destroy], User, id: user.id
      can :read, Subscription, user_id: user.id
      can [:read, :update, :destroy], Item, subscription: { user_id: user.id }
    end

    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end
end
