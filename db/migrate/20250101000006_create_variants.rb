class CreateVariants < ActiveRecord::Migration[7.2]
  def change
    create_table :variants do |t|
      t.references :product, null: false, foreign_key: true
      t.string :option_name, null: false
      t.string :option_value, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0

      t.timestamps
    end
  end
end
