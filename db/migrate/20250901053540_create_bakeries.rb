class CreateBakeries < ActiveRecord::Migration[8.0]
  def change
    create_table :bakeries do |t|
      t.string :name
      t.string :category
      t.string :address
      t.string :phone
      t.string :hours
      t.text :description

      t.timestamps
    end
  end
end
