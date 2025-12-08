class RemoveAddressFromBakeries < ActiveRecord::Migration[8.0]
  def change
    remove_column :bakeries, :address, :string
  end
end
