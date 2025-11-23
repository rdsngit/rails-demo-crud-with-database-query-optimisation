class Post < ApplicationRecord
  has_many :comments

  validates :name, presence: true, length: { minimum: 3, maximum: 255 }

  before_save do
    if name_changed?
      self.name = name.upcase_first
    end
  end
end
