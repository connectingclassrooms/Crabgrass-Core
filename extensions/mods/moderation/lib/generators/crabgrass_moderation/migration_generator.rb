require 'generators/crabgrass_moderation'
require 'rails/generators/migration'

module CrabgrassModeration
  module Generators

    class MigrationGenerator < Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(path)
        @offset ||= 10
        @offset -= 1
        (Time.now - @offset.seconds).utc.strftime("%Y%m%d%H%M%S")
      end

      def create_model_file
        migration_template "add_moderation_flags.rb",
          "db/migrate/add_moderation_flags.rb"
        migration_template "add_moderation_group_id_to_sites.rb",
          "db/migrate/add_moderation_group_id_to_sites.rb"
        migration_template "add_moderation_flags_to_chat_message.rb",
          "db/migrate/add_moderation_flags_to_chat_message.rb"
        migration_template "create_moderated_flags.rb",
          "db/migrate/create_moderated_flags.rb"
        migration_template "move_data_from_ratings_to_moderated_flags.rb",
          "db/migrate/move_data_from_ratings_to_moderated_flags.rb"
        migration_template "add_admins_may_moderate_flag_to_profiles.rb",
          "db/migrate/add_admins_may_moderate_flag_to_profiles.rb"
        migration_template "make_moderated_flags_polymorphic.rb",
          "db/migrate/make_moderated_flags_polymorphic.rb"
        migration_template "remove_sti_from_moderated_flags.rb",
          "db/migrate/remove_sti_from_moderated_flags.rb"
      end
    end
  end
end
