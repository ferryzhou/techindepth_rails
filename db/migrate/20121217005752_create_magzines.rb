class CreateMagzines < ActiveRecord::Migration
  def change
    create_table :magzines do |t|
      t.string :name

      t.timestamps
    end
  end
end
