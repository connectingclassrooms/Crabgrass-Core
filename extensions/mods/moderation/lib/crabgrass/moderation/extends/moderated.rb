module Crabgrass::Moderation
  module Extends::Moderated
    extend ActiveSupport::Concern

    included do
      has_many :moderated_flags, :as => :flagged, :dependent => :destroy
      after_update :update_moderated_flags
    end

    protected

    def update_moderated_flags
      updates = flag_updates
      moderated_flags.update_all(updates) if updates.present?
    end

    def flag_updates
      vetted_flag_update.merge deleted_flag_update
    end

    def vetted_flag_update
      if self.vetted_changed?
        { vetted_at: self.vetted && Time.now }
      else
        {}
      end
    end

    def deleted_flag_update
      if self.deleted_changed?
        { deleted_at: self.deleted? && Time.now }
      else
        {}
      end
    end

  end
end
