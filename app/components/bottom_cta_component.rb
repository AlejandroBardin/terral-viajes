# frozen_string_literal: true

class BottomCtaComponent < ViewComponent::Base
  def initialize
    @whatsapp_number = Setting.find_by(key: "whatsapp_number")&.value || "5493813416824"
  end
end
