require 'active_record'
require 'yaml'
require 'logger'

task :default => :migrate

# Migrating the DB
desc "Migrate the database through script ins db/migration. Target specific version VERSION=x"
task :migrate => :environment do

  if ENV["VERSION"]
    ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  else
    puts %{
    No database migration VERSION was specified.

    Example Usage:
      
        rake migrate VERSION=001
    }
  end

end


# Loading the db settings
task :environment do

  # Loading db config file
  db_config_file = YAML::load(File.open('db_config.yml'))

  # Connection to db
  ActiveRecord::Base.establish_connection db_config_file

  # Setting up loggin
  ActiveRecord::Base.logger = Logger.new(File.open('db.log', 'a'))

end
