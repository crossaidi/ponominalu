# A rails generator `ponominalu:install`. It creates a config file in `config/initializers/ponominalu.rb`.
class Ponominalu::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  # Creates the config file.
  def create_initializer
    copy_file 'initializer.rb', 'config/initializers/ponominalu.rb'
  end
end
