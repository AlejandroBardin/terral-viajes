class EnhancePackagesTable < ActiveRecord::Migration[8.1]
  def change
    # Campos para IA
    add_column :packages, :keyword, :string
    add_column :packages, :gpt_prompt, :text

    # Metadata estructurada (JSONB)
    add_column :packages, :extras, :jsonb, null: false, default: {}
    add_column :packages, :trip_purpose, :jsonb, null: false, default: []
    add_column :packages, :experience_type, :jsonb, null: false, default: []

    # Detalles adicionales
    add_column :packages, :min_passengers, :integer
    add_column :packages, :max_passengers, :integer
    add_column :packages, :min_age, :integer
    add_column :packages, :max_age, :integer
    add_column :packages, :kids_friendly, :boolean, default: false, null: false
    add_column :packages, :ideal_profile, :string, array: true, default: []
    add_column :packages, :start_date, :date
    add_column :packages, :end_date, :date

    # Índices para búsqueda y performance
    add_index :packages, :keyword, unique: true
    add_index :packages, :extras, using: :gin
    add_index :packages, :trip_purpose, using: :gin
    add_index :packages, :experience_type, using: :gin
    add_index :packages, :start_date
    add_index :packages, :kids_friendly
  end
end
