# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should have_many(:comments) }
  end

  describe 'associations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(255) }
  end

  describe '#before_save' do
    context 'when :name attribute has changed and starts with a lower case letter' do
      it 'sets the :name attribute\'s fist letter to a capital letter' do
        post = build(:post, name: 'a new post')
        post.save!
        expect(post.name).to eq('A new post')
      end
    end
  end
end
