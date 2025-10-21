class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :sale_price, precision: 10, scale: 2
      t.text :description
      t.integer :stock, default: 0
      t.references :category, null: false, foreign_key: true
      t.integer :status, default: 0
      t.decimal :weight, precision: 10, scale: 2
      t.string :sku
      t.string :brand

      t.timestamps
    end

    add_index :products, :slug, unique: true
    add_index :products, :sku, unique: true
  end
end
