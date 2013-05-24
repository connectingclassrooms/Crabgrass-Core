module Crabgrass::Moderation
  module Extends::Post
    included do
      has_many :moderated_flags, :as => :flagged, :dependent => :destroy
    end
  end
end
