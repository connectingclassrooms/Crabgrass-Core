class Admin::Context < Context

  def define_crumbs
    push_crumb :admin
  end

end
