class AddOperatingHoursToBakeries < ActiveRecord::Migration[8.0]
  def change
    add_column :bakeries, :operating_hours, :json
  end
end
