class AddChatwootFieldsToLeads < ActiveRecord::Migration[8.1]
  def change
    add_column :leads, :chatwoot_contact_id, :integer
    add_column :leads, :chatwoot_conversation_id, :integer
  end
end
