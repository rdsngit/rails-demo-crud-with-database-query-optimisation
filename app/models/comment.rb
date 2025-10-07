class Comment < ApplicationRecord
  belongs_to :post, counter_cache: true

  validates :content, presence: true, length: { minimum: 3, maximum: 255 }
end
