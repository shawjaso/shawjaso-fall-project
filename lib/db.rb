require 'active_record'
require 'yaml'
require 'logger'

# Loading the db info and establishing the a connection
db_config_file = 'db_config.yml'
db_config = YAML::load(File.open(db_config_file))
ActiveRecord::Base.establish_connection db_config

# Setting up logger
ActiveRecord::Base.logger = Logger.new(File.open('db.log', 'a'))

require_relative 'users'
require_relative 'friends'
require_relative 'links'

