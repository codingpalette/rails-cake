class FavoritesController < ApplicationController
  before_action :require_authentication
  before_action :set_bakery, only: [:toggle]
  
  def index
    @bakeries = current_user.favorite_bakeries.includes(:favorites)
  end
  
  def toggle
    favorite = current_user.favorites.find_by(bakery: @bakery)
    
    if favorite
      favorite.destroy
      favorited = false
    else
      current_user.favorites.create(bakery: @bakery)
      favorited = true
    end
    
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "favorite_button_#{@bakery.id}",
          partial: "shared/favorite_button",
          locals: { bakery: @bakery, favorited: favorited }
        )
      end
      format.html { redirect_back(fallback_location: @bakery) }
    end
  end
  
  private
  
  def set_bakery
    @bakery = Bakery.find(params[:bakery_id])
  end
end