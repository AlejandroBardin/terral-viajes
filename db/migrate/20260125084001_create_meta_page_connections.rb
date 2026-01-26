class CreateMetaPageConnections < ActiveRecord::Migration[8.1]
  def change
    create_table :meta_page_connections do |t|
      t.string :page_id
      t.string :page_name
      t.string :encrypted_access_token
      t.bigint :user_id
      t.boolean :is_active

      t.timestamps
    end
    add_index :meta_page_connections, :page_id
  end
end
