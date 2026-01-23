class CreateQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :questions do |t|
      t.references :package, null: false, foreign_key: true
      t.string :name, null: false
      t.text :answer
      t.integer :kind, default: 1
      t.integer :score
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end

    add_index :questions, [ :package_id, :enabled ]
    add_index :questions, :kind
  end
end
