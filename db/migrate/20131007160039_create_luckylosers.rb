class CreateLuckylosers < ActiveRecord::Migration
  def change
    create_table :luckylosers do |t|
      t.text :ranking
      t.date :startday
      t.timestamps
    end

    add_index :luckylosers, :startday, :unique => true
  end
end
