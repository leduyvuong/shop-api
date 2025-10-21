class CreateCoupons < ActiveRecord::Migration[7.2]
  def change
    create_table :coupons do |t|
      t.string :code, null: false
      t.integer :discount_type, null: false, default: 0
      t.decimal :discount_value, precision: 10, scale: 2, null: false
      t.integer :usage_limit
      t.integer :used_count, default: 0
      t.datetime :expired_at

      t.timestamps
    end

    add_index :coupons, :code, unique: true
  end
end
