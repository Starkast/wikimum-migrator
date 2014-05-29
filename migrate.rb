require 'sequel'

OLD_DB = Sequel.connect(ENV.fetch('OLD_DB_URL'))
NEW_DB = Sequel.connect(ENV.fetch('NEW_DB_URL'))

p OLD_DB.tables
p NEW_DB.tables
