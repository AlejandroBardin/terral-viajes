class Question < ApplicationRecord
  belongs_to :package
  has_many_attached :images

  # Categorías de preguntas para el flujo conversacional
  enum :kind, {
    welcome: 0,      # Preguntas de bienvenida/introducción
    description: 1,  # Descripción general del viaje
    detail: 2,       # Detalles específicos (horarios, incluye, etc.)
    closure: 3       # Preguntas de cierre/despedida
  }

  # Validaciones
  validates :name, presence: true, length: { minimum: 1, maximum: 150 }
  validates :answer, length: { maximum: 800 }, allow_blank: true
  validate :images_type_validation
  validate :images_size_validation

  # Callbacks
  before_save :sanitize_answer_html

  # Scopes
  scope :enabled, -> { where(enabled: true) }
  scope :ordered, -> { order(:kind, :created_at) }

  private

  def sanitize_answer_html
    return if answer.blank?

    self.answer = ActionController::Base.helpers.sanitize(
      answer,
      tags: %w[p br strong em b i u ul ol li],
      attributes: []
    )
  end

  def images_type_validation
    return unless images.attached?

    images.each do |image|
      unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
        errors.add(:images, "debe ser PNG, JPG o WebP")
      end
    end
  end

  def images_size_validation
    return unless images.attached?

    images.each do |image|
      if image.blob.byte_size > 6.megabytes
        errors.add(:images, "debe pesar menos de 6MB")
      end
    end
  end
end
