class Package < ApplicationRecord
  # Asociaciones
  has_many :questions, dependent: :destroy
  has_one_attached :main_image
  has_many_attached :gallery_images

  # Nested attributes para FAQs
  accepts_nested_attributes_for :questions,
    allow_destroy: true,
    reject_if: :all_blank

  # Validaciones existentes
  validates :title, :price, :stars, :duration, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :main_image, attached: true, content_type: %w[image/png image/jpeg image/webp],
                         size: { less_than: 5.megabytes }

  # Nuevas validaciones
  validates :keyword, uniqueness: true, allow_blank: true
  validates :gpt_prompt, length: { maximum: 1000 }, allow_blank: true
  validate :start_date_before_end_date, if: -> { start_date.present? && end_date.present? }

  # Scopes existentes
  scope :featured, -> { where(featured: true) }
  scope :by_price, -> { order(price: :asc) }

  # Nuevos scopes
  scope :upcoming, -> { where("start_date >= ?", Date.today) }
  scope :for_kids, -> { where(kids_friendly: true) }
  scope :active, -> { where(featured: true) }

  private

  def start_date_before_end_date
    return unless start_date > end_date

    errors.add(:start_date, "debe ser anterior a la fecha de finalizaci\u00F3n")
  end
end
