# Rails demo for CRUD database actions with query optimisation and styled with Tailwind CSS

This is a Ruby on Rails 8 demo app for create, read, update, and delete actions with database optimisations using the Ruby [bullet](https://github.com/flyerhzm/bullet) gem. It allows you to create posts with associated comments, view, edit, and delete them.

The database queries contain both unoptimised and optimised versions to see the effect of the bullet gem to indentify database performance issues and suggest improvements, such as by using eager loading of records and using the counter cache.

- Bullet gem: https://github.com/flyerhzm/bullet

The app is styled using Tailwind CSS.

- Tailwind CSS Rails gem: https://github.com/rails/tailwindcss-rails
- Tailwind CSS docs: https://tailwindcss.com/docs/

It contains model unit tests as well as integration request specs for CRUD operations - see section on tests below for more.

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

## Run the tests

The test libraries used include the following Ruby gems:

- [`factory_bot_rails`](https://github.com/thoughtbot/factory_bot_rails)
- [`rspec-rails`](https://github.com/rspec/rspec-rails)
- [`shoulda-matchers`](https://github.com/thoughtbot/shoulda-matchers)

The tests are located in [/spec](/spec):

- Unit tests for the models are located in [/spec/models](/spec/models)
- Request tests for rendering pages and CRUD operations are located in [/spec/requests](/spec/requests)

To run the test use the terminal command `bin/rspec`.

```
$ bin/rspec

Comment
  associations
    is expected to belong to post required: true counter_cache => true
  validations
    is expected to validate that :content cannot be empty/falsy
    is expected to validate that the length of :content is between 3 and 255
  #before_save
    when :content attribute has changed and starts with a lower case letter
      sets the :content attribute's fist letter to a capital letter

Post
  associations
    is expected to have many comments
  associations
    is expected to validate that :name cannot be empty/falsy
    is expected to validate that the length of :name is between 3 and 255
  #before_save
    when :name attribute has changed and starts with a lower case letter
      sets the :name attribute's fist letter to a capital letter

Posts
  GET /posts
    renders the table to display for posts with their comments
  GET /posts/new
    renders the new post page
  POST /posts
    creates a new post record and redirects to post show page
  GET /posts/:id
    renders the post show page with associated comments
  GET /posts/:id/edit
    renders the post edit page with associated comments
  PATCH /posts/:id/edit
    updates the post and redirects to post show page
  DELETE /posts/:id
    deletes the post and redirects to posts index page

Finished in 0.09225 seconds (files took 0.88722 seconds to load)
15 examples, 0 failures
```

## Use of Bullet gem for optimising database queries

The example database queries used for the `bullet` gem demo in this app are located in the `PostsController`.

- [/app/controllers/posts_controller.rb](/app/controllers/posts_controller.rb)

### Optimised query

The optimised query is to eager load the post record's associated comments in the `#index` controller action.

```rb
# app/controllers/posts_controller.rb
# Eager load comments to avoid N+1 queries
@posts = Post.includes(:comments)
```

### Query with N+1 warnings

When there is an N+1 query detected the Bullet gem should trigger errors to be displayed with suggestions for improving the query performance, like the following message:

```
USE eager loading detected
  Post => [:comments]
  Add to your query: .includes([:comments])
```

An example in this demo app is when it loads all post records in the posts controller then loads the associated comments records in the index view file via the posts table partial.

```rb
# app/controllers/posts_controller.rb
@posts = Post.all
```

```rb
# app/views/posts/_table.html.erb
<% post.comments.each do |comment| %>
```

### Query with counter cache warnings

When records are loaded and then counted using the `#count` method without using a counter cache the Bullet gem triggers a warning.

This can be seen in the demo app when post records load their associated comments then count them using `post.comments.count` rather than using the counter cache that is accessed using `post.comments_count`.

The `Comment` model has `counter_cache` set to `true` for its `belongs_to` association with the `Post` model.

- [/app/models/comment.rb](/app/models/comment.rb)

```rb
# app/models/comment.rb
class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true
```

The counter cache warning can be set to `true` in the controller and then triggered in the posts table partial.

- [/app/views/posts/_table.html.erb](/app/views/posts/_table.html.erb)

```rb
# app/views/posts/_table.html.erb
<% comments_count = @counter_cache_warning ? post.comments.count : post.comments_count %>
<%= pluralize(comments_count, 'Comment') %>:
```

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
