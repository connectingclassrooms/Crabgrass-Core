require 'rails/generators'

module CrabgrassModeration
  module Generators
    class Base < Rails::Generators::Base
      # Set the current directory as base for the inherited generators.
      def self.base_root
        File.dirname(__FILE__)
      end
    end
  end
end
