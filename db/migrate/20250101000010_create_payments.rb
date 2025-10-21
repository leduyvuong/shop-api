class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.string :method, null: false
      t.integer :status, default: 0
      t.string :transaction_id

      t.timestamps
    end

    add_index :payments, :transaction_id, unique: true
  end
end
