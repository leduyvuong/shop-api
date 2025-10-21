class CreateBlogPosts < ActiveRecord::Migration[7.2]
  def change
    create_table :blog_posts do |t|
      t.string :title, null: false
      t.string :slug, null: false
      t.text :content, null: false
      t.boolean :published, default: false

      t.timestamps
    end

    add_index :blog_posts, :slug, unique: true
  end
end
