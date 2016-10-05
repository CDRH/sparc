# sparc

Salmon Pueblo Archaeological Research Collection

## Setup

### Repository

```
git clone git@github.com:CDRH/sparc.git
cd sparc
```

Make sure that you have ruby version `2.3.1` installed and operating in this directory.  You may want to also make sure that you are installing gems into a distinct place from other ruby projects using the same version.

Once you have the correct ruby version, run the following. This may take a few minutes.

```
gem install bundler
bundle install
```

Now let's take a minute to set up your secrets file.

```
cp config/secrets.demo.yml config/secrets.yml
```

Now you can run `rake secret` as many times as you like to generate new secrets for your `config/secrets.yml` file.


### Database

This repo is using postgres, but you could switch it out for sqlite or mysql2 if needed.

If you do have postgres installed, you'll need to create a user that rails can use to manage three databases:  production, development, and test.

```
psql
create role sparc with createdb login password 'your_password_here'
```

Now you'll need to set up your database configuration.

```
cp config/database.demo.yml config/database.yml
```

Open `config/database.yml` and add the role (sparc) and password that you set above

Now set your dev and test databases up!  This step may take a few minutes while it loads all the spreadsheet data.

```
rake db:setup
```

You can also do it by hand, if you prefer:

```
rake db:create
rake db:migrate
rake db:seed
```

### Start Rails

```
rails s
```

You can view the site at `localhost:3000`
