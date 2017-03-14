class CreateVariationGroups < ActiveRecord::Migration
  def change
    create_table :variation_groups do |t|
      t.string :name

      t.timestamps
    end
  end
end
