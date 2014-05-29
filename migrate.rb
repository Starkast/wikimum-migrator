require 'sequel'

OLD_DB = Sequel.connect(ENV.fetch('OLD_DB_URL'), encoding: 'latin1')
NEW_DB = Sequel.connect(ENV.fetch('NEW_DB_URL'))

migrate_page = proc do |page|
  NEW_DB[:pages] << {
    title: page[:title].force_encoding('UTF-8'),
    slug: page[:shorthand_title].force_encoding('UTF-8')
  }
end

NEW_DB.transaction do
  OLD_DB[:pages].each(&migrate_page)
end
