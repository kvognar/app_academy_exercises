class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.integer :author_id, null: false
      t.references :commentable, polymorphic: true, null: false
      
      t.timestamps
    end
    
    add_index :comments, :author_id
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
  end
end
