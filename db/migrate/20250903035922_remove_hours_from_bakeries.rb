class RemoveHoursFromBakeries < ActiveRecord::Migration[8.0]
  def change
    remove_column :bakeries, :hours, :string
  end
end
