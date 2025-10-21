class CreateBanners < ActiveRecord::Migration[7.2]
  def change
    create_table :banners do |t|
      t.string :title, null: false
      t.string :image_url, null: false
      t.string :link_url
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
