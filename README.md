# Migration tool for [wikimum]

Add the environment variables to `.env`

    OLD_DB_URL=mysql2://[...]
    NEW_DB_URL=postgres://[...]

Start migrating

    bundle exec dotenv ruby migrate.rb

To access the old database, open a SSH tunnel:

    ssh -L3306:127.0.0.1:3306 phoo.starkast.net -Nv

[wikimum]: https://github.com/jage/wikimum
