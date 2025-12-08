class AddCloudflareImageFieldsToModels < ActiveRecord::Migration[8.0]
  def change
    # Bakery: multiple images
    add_column :bakeries, :cloudflare_image_ids, :json, default: []

    # MenuItem: single image
    add_column :menu_items, :cloudflare_image_id, :string

    # Note: multiple images
    add_column :notes, :cloudflare_image_ids, :json, default: []

    # User: single profile image
    add_column :users, :cloudflare_profile_image_id, :string
  end
end
