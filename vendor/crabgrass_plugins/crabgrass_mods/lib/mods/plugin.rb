module Mods::Plugin

  def load(initializer)
    info('loading plugin %s' % initializer.sub(RAILS_ROOT+'/',''), 1)
    super(initializer)
  end

  def define_page_type(type_name, options)
    Crabgrass::Page::ClassRegistrar.add(type_name.to_s, options)
  end

#  def add_to_model(model_name, lambda_block)
#    Mods.add_model_mixin(model_name, lambda_block)
#  end

  def extend_model(model_name, &block)
    Mods.add_model_mixin(model_name.to_s, block)
  end

  #
  # in development mode, rails unloads most classes and reloads them on each
  # request. plugins, by default, don't get reloaded. this can be a problem
  # when we have code, like models, in the plugin that rails unloaded.
  # you can force all plugins to get reloaded with "config.reload_plugins = true"
  #
  # alternately, you can call this method from the plugin's init.rb.
  # This will make sure that rails reloads the plugins classes.
  #
  # the logic for this is in Rails::Plugin::Loader#add_plugin_load_paths
  #
  def reloadable
    ActiveSupport::Dependencies.autoload_once_paths.delete config.paths.lib
    paths.app.each do |path|
      ActiveSupport::Dependencies.autoload_once_paths.delete path
    end
  end

  # make app/permissions to be considered part of the app paths for
  # a plugin.
  def app_paths
    super + [ File.join(directory, 'app', 'permissions') ]
  end

  ##
  ## DEPRECATED
  ##

  def load_once=(arg)
  end
  def override_views=(arg)
  end
  def apply_mixin_to_model(arg,arg2)
  end

end


