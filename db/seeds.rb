# Admin User
User.find_or_create_by!(email_address: "admin@terral.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end
puts "✅ Admin user ensured"

# Default Settings
[
  { key: "whatsapp_number", value: "5493813416824" },
  { key: "facebook_pixel", value: "1166448375323223" },
  { key: "hero_title", value: "Viajá con Terral" },
  { key: "hero_subtitle", value: "Descubrí los mejores destinos con nosotros" }
].each do |setting_attrs|
  Setting.find_or_create_by!(key: setting_attrs[:key]) do |setting|
    setting.value = setting_attrs[:value]
  end
end
puts "✅ Settings ensured"

# Sample Packages
[
  {
    title: "Mendoza a Pleno",
    price: 350000.00,
    stars: "⭐⭐⭐",
    duration: "4 Noches / 5 Días",
    dates: "Salida: 15 de Febrero",
    regime: "Media Pensión",
    featured: true,
    description: "Disfrutá de la tierra del buen sol y del buen vino. Excursiones imperdibles y bodegas de primera."
  },
  {
    title: "Cataratas del Iguazú",
    price: 420000.00,
    stars: "⭐⭐⭐⭐",
    duration: "5 Noches / 6 Días",
    dates: "Salida: 20 de Marzo",
    regime: "Desayuno",
    featured: true,
    description: "Viví una de las maravillas naturales del mundo. Incluye excursión lado Argentino y Brasileño."
  },
  {
    title: "Merlo San Luis",
    price: 280000.00,
    stars: "⭐⭐⭐",
    duration: "3 Noches / 4 Días",
    dates: "Salida: 10 de Abril",
    regime: "Pensión Completa",
    featured: false,
    description: "El tercer microclima del mundo te espera. Relax y naturaleza."
  }
].each do |package_attrs|
  Package.find_or_create_by!(title: package_attrs[:title]) do |package|
    package.assign_attributes(package_attrs)

    # Nuevos campos
    package.keyword = package_attrs[:title].parameterize
    package.gpt_prompt = "Eres un agente de ventas de #{package_attrs[:title]}. Sé amable y profesional."
    package.start_date = 1.month.from_now
    package.end_date = 1.month.from_now + 5.days
    package.kids_friendly = package_attrs[:title].include?("Merlo")
    package.extras = {
      incluye_traslado: true,
      incluye_seguro: true,
      comidas: package_attrs[:regime]
    }

    package.main_image.attach(
      io: File.open(Rails.root.join("db/fixtures/placeholder.jpg")),
      filename: "placeholder.jpg",
      content_type: "image/jpeg"
    )
  end
end
puts "✅ Packages ensured"

# Sample Questions (FAQs) para el primer paquete
mendoza = Package.find_by(title: "Mendoza a Pleno")
if mendoza && mendoza.questions.empty?
  [
    {
      name: "¿Qué incluye el paquete?",
      answer: "El paquete incluye traslados, alojamiento con media pensión, y excursiones a bodegas seleccionadas.",
      kind: :description,
      enabled: true
    },
    {
      name: "¿Cuál es la mejor época para ir?",
      answer: "La mejor época es de febrero a abril (vendimia) o septiembre a noviembre (primavera).",
      kind: :detail,
      enabled: true
    },
    {
      name: "¿Es apto para niños?",
      answer: "Sí, tenemos excursiones familiares aunque algunas bodegas tienen restricción de edad.",
      kind: :detail,
      enabled: true
    }
  ].each do |question_attrs|
    mendoza.questions.create!(question_attrs)
  end
  puts "✅ Questions for Mendoza package created"
end
