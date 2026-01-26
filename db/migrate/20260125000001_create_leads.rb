class CreateLeads < ActiveRecord::Migration[8.1]
  def change
    create_table :leads do |t|
      # Meta IDs
      t.string :meta_leadgen_id, null: false
      t.string :meta_form_id
      t.string :meta_ad_id
      t.string :meta_page_id

      # Source Info
      t.string :platform # 'fb' or 'ig'
      t.boolean :is_organic, default: false

      # Lead Data (PII)
      t.string :full_name
      t.string :email
      t.string :phone_number

      # Ad Context
      t.string :ad_headline
      t.text :ad_body

      # Status Tracking
      t.integer :status, default: 0 # 0: new, 1: contacted, etc.

      # JSON Dump for debugging
      t.jsonb :raw_data, default: {}

      t.timestamps
    end

    add_index :leads, :meta_leadgen_id, unique: true
    add_index :leads, :status
    add_index :leads, :created_at
  end
end
