class Ability
  include CanCan::Ability

  def initialize(admin=nil)
    if admin.is_a?(Admin)
      can :manage, :all
    else
      #TODO add abilities
    end
  end
end
