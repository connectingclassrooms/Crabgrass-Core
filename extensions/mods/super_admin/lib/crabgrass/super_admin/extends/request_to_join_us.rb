##
## Allow superadmins to approve all group requests
##

module Crabgrass::SuperAdmin
  module Extends::RequestToJoinUs

    def may_approve_with_superadmin(user)
      return true if superadmin?
      return may_approve_without_superadmin?(user)
    end

    included do
      alias_method_chain :may_approve?, :superadmin
    end

end



