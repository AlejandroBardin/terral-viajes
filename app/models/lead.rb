class Lead < ApplicationRecord
  # Attachments
  has_one_attached :ad_creative_snapshot

  # Validations
  validates :meta_leadgen_id, presence: true, uniqueness: true
  validates :platform, inclusion: { in: %w[fb ig] }, allow_nil: true

  # Enums
  enum :status, {
    new_lead: 0,
    contacted: 1,
    qualified: 2,
    converted: 3,
    lost: 4
  }, default: :new_lead

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :organic, -> { where(is_organic: true) }
  scope :paid, -> { where(is_organic: false) }

  def initials
    return "??" if full_name.blank?
    full_name.split.map(&:first).join.upcase[0..1]
  end

  def platform_icon
    platform == "ig" ? "bi-instagram" : "bi-facebook"
  end
end
