class SeparateAddressFields < ActiveRecord::Migration[8.0]
  def change
    add_column :bakeries, :postcode, :string
    add_column :bakeries, :road_address, :string
    add_column :bakeries, :jibun_address, :string
    add_column :bakeries, :detail_address, :string
    add_column :bakeries, :extra_address, :string
    
    # 기존 address 컬럼은 유지 (호환성을 위해)
  end
end
