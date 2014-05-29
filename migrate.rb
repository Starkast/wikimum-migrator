require 'sequel'

OLD_DB = Sequel.connect(ENV.fetch('OLD_DB_URL'), encoding: 'latin1')
NEW_DB = Sequel.connect(ENV.fetch('NEW_DB_URL'))

migrate_page = proc do |page|
  NEW_DB[:pages] << {
    title:                page[:title].force_encoding('UTF-8'),
    slug:                 page[:shorthand_title].force_encoding('UTF-8'),
    title_char:           page[:title_char].force_encoding('UTF-8'),
    content:              page[:content].force_encoding('UTF-8'),
    compiled_content:     page[:compiled_content].force_encoding('UTF-8'),
    comment:              page[:comment].force_encoding('UTF-8'),
    compiled_comment:     page[:compiled_comment].force_encoding('UTF-8'),
    description:          page[:description].force_encoding('UTF-8'),
    compiled_description: page[:compiled_description].force_encoding('UTF-8'),
    created_on:           page[:created_on],
    updated_on:           page[:updated_on],
    markup:               page[:markup],
  }
end

NEW_DB.transaction do
  OLD_DB[:pages].each(&migrate_page)
end
