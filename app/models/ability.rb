class Ability
  include CanCan::Ability

  def initialize(user, radio)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :admin, :dashboard
      can :admin, :radios
      can :manage, :all
    elsif user.owner?
      can :manage, Radio do |radio|
        can_manage_radio?(user, radio)
      end
      can :manage, Show if can_manage_radio?(user, radio)
      can :manage, Subscription, user_id: user.id
    elsif user.dj?
      can :read, Podcast
      can :read, "broadcasting_help"
      cannot :admin
    else
      can :read, ScheduledShow
      cannot :admin
    end
  end

  private
  def can_manage_radio?(user, radio)
    user.managable_radios.include? radio
  end
end
