class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    else
      can [:update, :destroy], Item, subscription: { user_id: user.id }
    end

    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end
end
