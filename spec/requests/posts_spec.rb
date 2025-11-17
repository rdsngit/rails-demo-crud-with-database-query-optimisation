# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe 'GET /posts' do
    let!(:post1) { create(:post, name: 'First Post', comments: [ build(:comment, content: 'Comment for First Post') ]) }

    it 'renders the table to display for posts with their comments' do
      get '/posts'
      expect(response.body).to include('<th>Post</th>')
      expect(response.body).to include('<td>First Post</td>')
      expect(response.body).to include('<th>Comments</th>')
      expect(response.body).to include('Comment for First Post')
    end
  end

  describe 'GET /posts/new' do
    it 'renders the new post page' do
      get '/posts/new'
      expect(response.body).to include('<h1>New post</h1>')
    end
  end

  describe 'POST /posts' do
    it 'creates a new post record and redirects to post show page' do
      post_params = { post: { name: 'Test Post' } }
      expect { post '/posts', params: post_params }.to change(Post, :count).by(1)
      expect(response).to redirect_to('/posts/1')
    end
  end

  describe 'GET /posts/:id' do
    let!(:post1) { create(:post, name: 'First Post', comments: [ build(:comment, content: 'Comment for First Post') ]) }

    it 'renders the post show page with associated comments' do
      get "/posts/#{post1.id}"
      expect(response.body).to include('<h1> Post Details </h1>')
      expect(response.body).to include('First Post')
      expect(response.body).to include('Comment for First Post')
    end
  end

  describe 'GET /posts/:id/edit' do
    let!(:post1) { create(:post, name: 'First Post', comments: [ build(:comment, content: 'Comment for First Post') ]) }

    it 'renders the post edit page with associated comments' do
      get "/posts/#{post1.id}/edit"
      expect(response.body).to include('<h1>Editing post</h1>')
      expect(response.body).to include('First Post')
      expect(response.body).to include('Update Post')
    end
  end

  describe 'PATCH /posts/:id/edit' do
    let!(:post1) { create(:post, name: 'First Post', comments: [ build(:comment, content: 'Comment for First Post') ]) }
    let(:post_update_params) { { post: { name: "First Post Edit" } } }

    it 'updates the post and redirects to post show page' do
      patch "/posts/#{post1.id}", params: post_update_params
      expect(response).to redirect_to(post1)
      follow_redirect!
      expect(response.body).to include('Post was successfully updated.')
      expect(response.body).to include('First Post Edit')
    end
  end

  describe 'DELETE /posts/:id' do
    let!(:post1) { create(:post, name: 'First Post', comments: [ build(:comment, content: 'Comment for First Post') ]) }

    it 'deletes the post and redirects to posts index page' do
      delete "/posts/#{post1.id}"
      expect(response).to redirect_to('/posts')
      follow_redirect!
      expect(response.body).to include('Post was successfully destroyed.')
    end
  end
end
