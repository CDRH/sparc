# sparc

Salmon Pueblo Archaeological Research Collection

This is an application to work with the SPARC data derived from the spreadsheets.

The interface is primarily driven by the ActiveScaffold gem to provide a simple and intuitive editing interface with minimal effort to setup and customize.

https://github.com/activescaffold/active_scaffold

## Setup

### Repository

```bash
git clone git@github.com:CDRH/sparc.git
cd sparc
```

Make sure that you have the latest Ruby 2.3.x version installed and operating in this directory.  You may want to also make sure that you are installing gems into a distinct place from other Ruby projects using the same version. RVM is recommended for this.

The `pg` gem requires `postgresql-devel` be installed on the system before the gem will bundle.

Once you have the correct ruby version, run the following. This may take a few minutes.

```bash
gem install bundler
bundle install
```

Now let's take a minute to set up your secrets file.

```bash
cp config/secrets.demo.yml config/secrets.yml
```

Now you can run `rails secret` as many times as you like to generate new secrets for your `config/secrets.yml` file.

### Libraries / Apache

Create a symlink for the universal viewer files.

```
ln -s /path/to/app/public/uv-2.0.2 /path/to/app/public/assets/uv-2.0.2
```

Set up your apache configuration to allow symlinks:

```
Options FollowSymLinks
```

### Database

This repo is using postgres, but you could switch it out for sqlite or mysql2 if needed.

If you do have postgres installed, you'll need to create a user that rails can use to manage three databases:  production, development, and test.

`sudo -i -u postgres createuser -d -P sparc`

Now you'll need to set up your database configuration.

```bash
cp config/database.demo.yml config/database.yml
```

Open `config/database.yml` and add the role (sparc) and password that you set above

Now set your dev and test databases up!  This step may take a few minutes while it loads all the spreadsheet data.

```bash
rake db:setup
```

You can also do it by hand, if you prefer:

```bash
rake db:create
rake db:migrate
rake db:seed
```

### Start Rails

```bash
rails s
```

You can view the site at `localhost:3000`

### Check Image Status

Images should be stored in `app/assets/images/field` in the `large` and `thumb` directories. To check if all the images and there and if each image in the directories has metadata, run the following, respectively:

```
rake images:find_missing
rake images:find_extra
```

### Regenerate documents.csv

In the event that new documents have been added, filenames altered, etc, you may need to regenerate the file used to seed the database.  First, open up `lib/tasks/document.rake` and verify that the path to the jpegs is correct, for your system.  The path was hardcoded because it is (hopefully) unlikely that the documents.csv file will need to be regenerated.

```
DOCUMENT_PATH = "/your/path/here"
```

Verify that [exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/) is installed on your system, then run:

```
rake documents:create_csv
```

__NOTE: This may take up to an hour to run, depending on your machine!__  The script pulls out metadata from the images with exiftool, which is where the bottleneck occurs.

### Run Tests

```bash
rake test
```

Because of the way that foreign keys are set up currently, in order to run the tests you will have to grant the postgres role you're using superuser privileges on the rails test database.  If you just want to grant sweeping privileges, you can do this:

`sudo -i -u postgres psql`:

```sql
# Add privileges
ALTER ROLE sparc WITH SUPERUSER;

# Revoke
ALTER ROLE sparc WITH NOSUPERUSER;

# Exit psql shell
exit  # or Ctrl+D
```

I do not recommend doing the above in a production environment.  In the near future we should figure out how we would like cascading deletes, etc, to work for these PKs.
