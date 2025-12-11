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

Set up your config file and fill out the location of your iiif_server:

```
cp config/config.example.yml config/config.yml
```

Now let's take a minute to set up your secrets file.

```bash
cp config/secrets.demo.yml config/secrets.yml
```

Now you can run `rails secret` as many times as you like to generate new secrets for your `config/secrets.yml` file.

### Apache Config

The following Apache configuration is required in the production site's
`<VirtualHost>` block:

```apacheconf
  # Necessary for unit names with slashes
  AllowEncodedSlashes NoDecode

  # CORS Header
  SetEnvIf Request_URI "^/documents/.+/\w+\.json$" IIIF=1
  Header set Access-Control-Allow-Origin * env=IIIF
  UnsetEnv IIIF
```

#### Static JavaScript

Universal Viewer references other files relative to each other, so it must be
served as static assets outside of the Rails asset pipeline.

This is best managed with Apache like this:

```apacheconf
# Universal Viewer Static Assets
Alias /assets/uv-2.0.2 /var/local/www/rails/salmonpueblo.org/public/uv-2.0.2
<Location /assets/uv-2.0.2/>
  PassengerEnabled off

  Require all granted
</Location>

Alias /uv-2.0.2 /var/local/www/rails/salmonpueblo.org/public/uv-2.0.2
<Location /uv-2.0.2/>
  PassengerEnabled off

  Require all granted
</Location>
```

It's unclear how to remove the prefix of `/assets/` to some of the UV URLs, but
updating UV to a newer version might simplify the URLs it uses here.
```


```
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

Before you get too much farther, you will need to locate and add `Burials.xlsx`, which is not stored in this repository. Otherwise, comment out Burials at the bottom of `seeds.rb`.

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

### "Seed" More Data

There are several other steps that need to be taken to prepare the database.

Add descriptions to units and zones:
```
rails units:description
```

Mark images which do exist on the file system. You will need to generate that list ahead of time by going to the IIIF directory and running:
```
find field polaroids -type f > all_mediaserver_images.txt
```
Copy the text file results to `reports/all_mediaserver_images.txt` and then run:

```
rails images:file_exists
```

If you don't care if some images are broken and just want to see some images (for example, if working in development), run the following in your rails console (`rails c`):

```
Image.update_all(file_exists: true)
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

### Generate assets

To generate assets (production only):

```
rails assets:precompile RAILS_ENV=production
```

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

### Redact Images

When asked to redact images, take the following steps.

Verify which image you need to redact. The files themselves are arranged in two directories, polaroid and field, but while the filenames have nothing prepended to the number, the database lists polaroids as `PA0#####`. If you are redacting a polaroid, make sure that you use `PA0` in the following commands.

Navigate to the production rails application.

** USE EXTREME CAUTION WHEN RUNNING CONSOLE DB OPERATIONS ON THE PRODUCTION SERVER **

```
rails c production
> # field image
> i = Image.find_by(image_no: "12038")
> i.update_attributes(image_human_remain_id: 2)
>
> # polaroid image
> i = Image.find_by(image_no: "PA012038")
> i.update_attributes(image_human_remain_id: 2)
> exit
```

Refresh the website to make sure that the image is no longer available in the gallery views.

Now manually move the redacted image.  Navigate to the mediaserver directory housing the images and move the image in question into the `sensitive` directory.  This means it will not be available to view through the media server / IIIF URLs.
