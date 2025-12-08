class AddStoreTypeAndParentToBakeries < ActiveRecord::Migration[8.0]
  def change
    add_column :bakeries, :store_type, :string, default: 'main', null: false
    add_reference :bakeries, :parent, null: true, foreign_key: { to_table: :bakeries }
  end
end
