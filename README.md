# Rails Database Performance with Bullet Gem Demo

The Bullet gem is designed to indentify database performance issues and suggest improvements, such as by using eager loading of records.

- Bullet gem: https://github.com/flyerhzm/bullet

## Setup

Install the Ruby version in the `.ruby-version` file then run the terminal command `bundle install`.

## Run the web app

Using the terminal navigate to the root of the project directory and run the command:

```sh
bin/dev
```

Then open your internet browser, such as Chrome, and visit `http://localhost:3000/`

Click on the links to view the effect of the optimised database query compared to the N+1 query.

## Use of Bullet library for database queries

When there is an N+1 query detected it should show an error and suggestion for improving the query performance, like the following message:

```
USE eager loading detected
  Post => [:comments]
  Add to your query: .includes([:comments])
```
