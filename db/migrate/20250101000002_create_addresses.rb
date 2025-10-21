class CreateAddresses < ActiveRecord::Migration[7.2]
  def change
    create_table :addresses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :phone, null: false
      t.string :province, null: false
      t.string :district, null: false
      t.string :ward, null: false
      t.string :street, null: false
      t.boolean :default, default: false

      t.timestamps
    end
  end
end
