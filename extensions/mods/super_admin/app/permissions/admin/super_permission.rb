module Admin::SuperPermission
  def may_super?
    logged_in? && current_user.superadmin?
  end
end
