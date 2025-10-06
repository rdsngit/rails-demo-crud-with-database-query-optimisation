class ChangeCommentNameToContent < ActiveRecord::Migration[8.0]
  def change
    rename_column :comments, :name, :content
  end
end
