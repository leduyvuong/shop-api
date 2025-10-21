class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :total_price, precision: 12, scale: 2, default: 0
      t.integer :status, default: 0
      t.string :payment_method
      t.decimal :shipping_fee, precision: 10, scale: 2, default: 0
      t.references :address, null: false, foreign_key: true

      t.timestamps
    end
  end
end
