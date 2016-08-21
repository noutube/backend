class Ability
  include CanCan::Ability

  def initialize(user)
    if user.has_role? :admin
      can :manage, :all
    end

    can :read, ActiveAdmin::Page, name: 'Dashboard'
  end
end
