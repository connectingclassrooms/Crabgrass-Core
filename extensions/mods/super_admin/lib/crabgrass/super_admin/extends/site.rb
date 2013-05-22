module Crabgrass::SuperAdmin
  module Extends::Site
    extend ActiveSupport::Concern

    included do
      belongs_to :super_admin_group, :class_name => "Group"
    end
  end
end

