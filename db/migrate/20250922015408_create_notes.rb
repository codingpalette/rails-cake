class CreateNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :notes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :bakery, null: false, foreign_key: true
      t.text :content
      t.date :visit_date

      t.timestamps
    end
  end
end
