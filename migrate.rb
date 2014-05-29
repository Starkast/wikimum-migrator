require 'sequel'
require 'ruby-progressbar'

OLD_DB = Sequel.connect(ENV.fetch('OLD_DB_URL'), encoding: 'latin1')
NEW_DB = Sequel.connect(ENV.fetch('NEW_DB_URL'))

def migrate_page(page)
  page = NEW_DB[:pages] << {
    title:                page[:title].force_encoding('UTF-8'),
    slug:                 page[:shorthand_title].force_encoding('UTF-8').downcase,
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
    revision:             page[:revision],
  }
end

def migrate_revision(revision)
  old_page = OLD_DB[:pages].
    where(id: revision[:page_id]).
    first

  new_page = NEW_DB[:pages].
    where(slug: old_page[:shorthand_title].force_encoding('UTF-8').downcase).
    first

  unless new_page
    puts "Skipped #{revision[:title]}"
    return
  end

  NEW_DB[:revisions] << {
    page_id:              new_page[:id],
    title:                revision[:title].force_encoding('UTF-8'),
    slug:                 revision[:shorthand_title].force_encoding('UTF-8').downcase,
    title_char:           revision[:title_char].force_encoding('UTF-8'),
    content:              revision[:content].force_encoding('UTF-8'),
    compiled_content:     revision[:compiled_content].force_encoding('UTF-8'),
    comment:              revision[:comment].force_encoding('UTF-8'),
    compiled_comment:     revision[:compiled_comment].force_encoding('UTF-8'),
    description:          revision[:description].force_encoding('UTF-8'),
    compiled_description: revision[:compiled_description].force_encoding('UTF-8'),
    created_on:           revision[:created_on],
    updated_on:           revision[:updated_on],
    markup:               revision[:markup],
    revision:             revision[:revision],
  }
end

NEW_DB.transaction do
  count = OLD_DB[:pages].count + OLD_DB[:revisions].count

  progress_bar = ProgressBar.create(total: count)

  OLD_DB[:pages].each do |page|
    progress_bar.increment
    migrate_page(page)
  end

  OLD_DB[:revisions].each do |revision|
    progress_bar.increment
    migrate_revision(revision)
  end
end
