class AddSourceAuthorToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :source, :string
    add_column :articles, :author, :string
  end
end
