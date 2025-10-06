# Rails demo for CRUD database actions with query optimisation and styled with Tailwind CSS

This is a Ruby on Rails 8 demo app for create, read, update, and delete actions with database optimisations using the Ruby [bullet](https://github.com/flyerhzm/bullet) gem. It allows you to create posts with associated comments, view, edit, and delete them.

The database queries contain both unoptimised and optimised versions to see the effect of the bullet gem to indentify database performance issues and suggest improvements, such as by using eager loading of records.

- Bullet gem: https://github.com/flyerhzm/bullet

The app is styled using Tailwind CSS.

- Tailwind CSS Rails gem: https://github.com/rails/tailwindcss-rails
- Tailwind CSS docs: https://tailwindcss.com/docs/

## Setup

Install the Ruby version in the `.ruby-version` file then run the setup script to install the libraries and create the database.

```sh
./bin/setup
```

You can seed the database with some predefined posts and comments records using the command:

```sh
./bin/rails db:seed
```

## Run the web app

Using the terminal navigate to the root of the project directory and run the command:

```sh
bin/dev
```

Then open your internet browser, such as Chrome, and visit `http://localhost:3000/`

You can create, view, edit and delete posts records as well as their associated comments.

Click on the links to view the effect of the optimised database query compared to the N+1 query.

## Use of Bullet gem for optimising database queries

When there is an N+1 query detected the Bullet gem should trigger errors to be displayed with suggestions for improving the query performance, like the following message:

```
USE eager loading detected
  Post => [:comments]
  Add to your query: .includes([:comments])
```

An example in this demo app is when it loads all post records in the posts controller then loads the associated comments records in the index view file.

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/controllers/posts_controller.rb#L7

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/views/posts/_table.html.erb#L17

The optimised query is to eager load the associated comments in the controller action.

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/controllers/posts_controller.rb#L9-L10

## Tailwind CSS styling

This app's webpages are styled using [Tailwind CSS](https://tailwindcss.com).

The customised CSS styles for the app are defined in: [/app/assets/tailwind/application.css](/app/assets/tailwind/application.css)

## Screenshots

![screenshot of posts with comments table](/screenshots/screenshot-posts-with-comments-table.png)

![screenshot of N+1 query warning](/screenshots/screenshot-n+1-query-warning.png)
