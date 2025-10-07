# Rails demo for CRUD database actions with query optimisation and styled with Tailwind CSS

This is a Ruby on Rails 8 demo app for create, read, update, and delete actions with database optimisations using the Ruby [bullet](https://github.com/flyerhzm/bullet) gem. It allows you to create posts with associated comments, view, edit, and delete them.

The database queries contain both unoptimised and optimised versions to see the effect of the bullet gem to indentify database performance issues and suggest improvements, such as by using eager loading of records and using the counter cache.

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

Click on the links to view the effect of the optimised database query compared to the N+1 query warning and counter cache warning.

## Use of Bullet gem for optimising database queries

### Optimised query

The optimised query is to eager load the associated comments in the controller action.

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/controllers/posts_controller.rb#L9-L10

### Query with N+1 warnings

When there is an N+1 query detected the Bullet gem should trigger errors to be displayed with suggestions for improving the query performance, like the following message:

```
USE eager loading detected
  Post => [:comments]
  Add to your query: .includes([:comments])
```

An example in this demo app is when it loads all post records in the posts controller then loads the associated comments records in the index view file.

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/controllers/posts_controller.rb#L7

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/98c91e7aaa86e8fe69d9d31a286ec300c5f7e4ba/app/views/posts/_table.html.erb#L17

### Query with counter cache warnings

When records count is loaded without using a counter cache the Bullet gem triggers a warning.

This can be seen in the demo app when post records load their associated comments then count them using `post.comments.count` rather than using the counter cache that is accessed using `post.comments_count`.

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/e2b6fae87340603a05d41b59a8b05b0e99759177/app/models/comment.rb#L2

https://github.com/rdsngit/rails-demo-crud-with-database-query-optimisation/blob/2884187e8e63f716570ea72243b734231072ff64/app/views/posts/_table.html.erb#L19-L20

The query can also be manually run in the rails console using `bin/rails c` and running the following code to see the additional query for the count that is activated.

```
rails-database-performance-bullet-gem-demo(dev)> Post.first.comments_count
  Post Load (0.5ms)  SELECT "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT 1 /*application='RailsDatabasePerformanceBulletGemDemo'*/
=> 2
rails-database-performance-bullet-gem-demo(dev)> Post.first.comments.count
  Post Load (0.5ms)  SELECT "posts".* FROM "posts" ORDER BY "posts"."id" ASC LIMIT 1 /*application='RailsDatabasePerformanceBulletGemDemo'*/
  Comment Count (0.2ms)  SELECT COUNT(*) FROM "comments" WHERE "comments"."post_id" = 1 /*application='RailsDatabasePerformanceBulletGemDemo'*/
=> 2
```

## Tailwind CSS styling

This app's webpages are styled using [Tailwind CSS](https://tailwindcss.com).

The customised CSS styles for the app are defined in: [/app/assets/tailwind/application.css](/app/assets/tailwind/application.css)

## Screenshots

![screenshot of posts with optimised query](/screenshots/screenshot-posts-with-optimised-query.png)

![screenshot of N+1 query warning](/screenshots/screenshot-n+1-query-warning.png)

![screenshot of query with counter cache warning](/screenshots/screenshot-query-counter-cache-warning.png)
