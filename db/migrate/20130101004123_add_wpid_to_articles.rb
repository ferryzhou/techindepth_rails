class AddWpidToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :wpid, :integer
  end
end
