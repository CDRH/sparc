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

Make sure that you have ruby version `2.3.1` installed and operating in this directory.  You may want to also make sure that you are installing gems into a distinct place from other ruby projects using the same version.

Once you have the correct ruby version, run the following. This may take a few minutes.

```bash
gem install bundler
bundle install
```

Now let's take a minute to set up your secrets file.

```bash
cp config/secrets.demo.yml config/secrets.yml
```

Now you can run `rake secret` as many times as you like to generate new secrets for your `config/secrets.yml` file.


### Database

This repo is using postgres, but you could switch it out for sqlite or mysql2 if needed.

If you do have postgres installed, you'll need to create a user that rails can use to manage three databases:  production, development, and test.

`su postgres`:

- `psql`:
```sql
CREATE ROLE sparc WITH CREATEDB LOGIN PASSWORD 'your_password_here';

# Exit psql shell
exit  # or Ctrl+D

# Exit bash shell as postgres user
exit  # Ctrl+D
```

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

### Run Tests

```bash
rake test
```

Because of the way that foreign keys are set up currently, in order to run the tests you will have to grant the postgres role you're using superuser privileges on the rails test database.  If you just want to grant sweeping privileges, you can do this:

`su postgres`:

- `psql`:

```sql
# Add privileges
ALTER ROLE sparc WITH SUPERUSER;

# Revoke
ALTER ROLE sparc WITH NOSUPERUSER;

# Exit psql shell
exit  # or Ctrl+D

# Exit bash shell as postgres user
exit  # Ctrl+D
```

I do not recommend doing the above in a production environment.  In the near future we should figure out how we would like cascading deletes, etc, to work for these PKs.
