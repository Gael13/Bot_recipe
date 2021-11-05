class CreateIngredientFridges < ActiveRecord::Migration[5.2]
  def change
    create_table :ingredient_fridges do |t|
      t.integer :fridge_id
      t.integer :ingredient_id
      t.string :quantity

      t.timestamps
    end
  end
end
