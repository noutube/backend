class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :update, :destroy], User, id: user.id
      can [:create, :read, :update, :takeout], Subscription, user_id: user.id
      can [:create, :read, :update], Item, user_id: user.id
    else
      can :create, User
    end
  end
end
