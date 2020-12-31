class CreatePlaysTable < ActiveRecord::Migration
  def change
    create_table :plays do |t|
      t.string :name
      t.string :type
      t.string :genre
      t.integer :cast_total
      t.text :synopsis
    end
  end
end
