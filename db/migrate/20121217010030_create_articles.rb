class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.string :link
      t.text :content
      t.datetime :pubdate
      t.references :magzine

      t.timestamps
    end
    add_index :articles, :magzine_id
  end
end
