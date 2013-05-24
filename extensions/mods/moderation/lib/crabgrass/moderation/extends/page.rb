module Crabgrass::Moderation
  module Extends::Page
    extend ActiveSupport::Concern

    included do
      has_many :moderated_flags, :as => :flagged, :dependent => :destroy
    end
  end
end
