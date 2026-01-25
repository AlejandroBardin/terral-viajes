class MetaPageConnection < ApplicationRecord
  # Encrypt the access token securely
  encrypts :encrypted_access_token

  validates :page_id, presence: true, uniqueness: true
  validates :encrypted_access_token, presence: true

  scope :active, -> { where(is_active: true) }

  def self.valid_token_for(page_id)
    find_by(page_id: page_id, is_active: true)&.encrypted_access_token
  end
end
