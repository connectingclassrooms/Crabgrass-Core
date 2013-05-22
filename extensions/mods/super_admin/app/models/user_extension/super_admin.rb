module UserExtension::SuperAdmin

  def self.included(base)
    base.extend(ClassMethods)
    base.instance_eval do
      include InstanceMethods
      alias_method_chain :may!, :superadmin
      alias_method_chain :may?, :superadmin
    end
  end

  module ClassMethods
    # Removes the superadmins from some user-lists
    def inactive_user_ids
      if Site.current.super_admin_group
        Site.current.super_admin_group.user_ids
      else
        false
      end
    end
  end

  module InstanceMethods
    # Returns true if self is a super admin on site. Defaults to the
    # current site.
    def superadmin?(site=Site.current)
      if site
        self.group_ids.include?(site.super_admin_group_id)
      else
        false
      end
    end

    def may_with_superadmin!(perm, object)
      return true if superadmin?
      return may_without_superadmin!(perm, object)
    end

    def may_with_superadmin?(perm, object)
      return true if superadmin?
      return may_without_superadmin?(perm, object)
    end

  end

end

