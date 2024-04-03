class BlingOrderItemPolicy < ApplicationPolicy
  def others_status?
    index?
  end
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
