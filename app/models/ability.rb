class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can [:read, :update, :destroy], User, id: user.id
      can [:read, :takeout], Subscription, user_id: user.id
      can [:read, :update, :destroy], Item, user_id: user.id
    else
      can :create, User
    end
  end
end
