class Package < ApplicationRecord
  has_one_attached :main_image
  has_many_attached :gallery_images

  validates :title, :price, :stars, :duration, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :main_image, attached: true, content_type: %w[image/png image/jpeg image/webp],
                         size: { less_than: 5.megabytes }

  scope :featured, -> { where(featured: true) }
  scope :by_price, -> { order(price: :asc) }
end
