require File.expand_path(File.dirname(__FILE__) + "/lib/insert_commands.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/rake_commands.rb")

class HeadstartGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      app_name = File.expand_path(File.dirname(__FILE__)).split("/").last
      m.directory File.join("config", "initializers")
      m.file "headstart.rb",  "config/initializers/headstart.rb"
      m.file "headstart.yml", "config/headstart.yml"

      m.directory File.join("app", "views", "layouts")
      m.directory File.join("app", "views", "sessions")
      m.file "application.html.erb", "app/views/layouts/application.html.erb"
      m.file "app/views/sessions/index.html.erb", "app/views/sessions/index.html.erb"

      m.directory File.join("public", "stylesheets")
      m.file "style.css", "public/stylesheets/style.css"
      m.file "report.css", "public/stylesheets/report.css"
      m.file "reset.css", "public/stylesheets/reset.css"
      m.file "text.css", "public/stylesheets/text.css"
      m.file "layout.css", "public/stylesheets/layout.css"

      m.file "xd_receiver.html", "public/xd_receiver.html"
      m.file "xd_receiver_ssl.html", "public/xd_receiver_ssl.html"
      
      m.file "app/controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"
      m.insert_into "app/controllers/application_controller.rb",
                    "include Headstart::Authentication"
      
      user_model = "app/models/user.rb"
      if File.exists?(user_model)
        m.insert_into user_model, "include Headstart::User"
      else
        m.directory File.join("app", "models")
        m.file "user.rb", user_model
      end
      
      m.insert_into "config/routes.rb",
                    "Headstart::Routes.draw(map)"

      m.directory File.join("test", "factories")
      m.file "factories.rb", "test/factories/user.rb"

      m.migration_template "migrations/#{migration_source_name}.rb",
                           'db/migrate',
                           :migration_file_name => "headstart_#{migration_target_name}"

      m.readme "README"
    end
  end

  def schema_version_constant
    if upgrading_headstart_again?
      "To#{schema_version.gsub('_', '')}"
    end
  end

  private

  def migration_source_name
    if ActiveRecord::Base.connection.table_exists?(:users)
      'update_users'
    else
      'create_users'
    end
  end

  def migration_target_name
    if upgrading_headstart_again?
      "update_users_to_#{schema_version}"
    else
      'create_users'
    end
  end

  def schema_version
    IO.read(File.join(File.dirname(__FILE__), '..', '..', 'VERSION')).strip.gsub(/[^\d]/, '_')
  end

  def upgrading_headstart_again?
    ActiveRecord::Base.connection.table_exists?(:users)
  end

end
