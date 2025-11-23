# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { should belong_to(:post).counter_cache }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(3).is_at_most(255) }
  end

  describe '#before_save' do
    context 'when :content attribute has changed and starts with a lower case letter' do
      it 'sets the :content attribute\'s fist letter to a capital letter' do
        comment = build(:comment, content: 'a new comment')
        comment.save!
        expect(comment.content).to eq('A new comment')
      end
    end
  end
end
