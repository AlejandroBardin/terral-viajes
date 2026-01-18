class CreatePackages < ActiveRecord::Migration[8.1]
  def change
    create_table :packages do |t|
      t.string :title
      t.decimal :price, precision: 10, scale: 2
      t.string :stars
      t.string :duration
      t.string :dates
      t.string :regime
      t.boolean :featured
      t.text :description

      t.timestamps
    end
  end
end
