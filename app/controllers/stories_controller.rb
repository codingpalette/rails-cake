class StoriesController < ApplicationController
  allow_unauthenticated_access only: [:index]
  before_action :set_bakery

  def index
    @public_notes = @bakery.notes.public_notes.includes(:user).recent
  end

  private

  def set_bakery
    @bakery = Bakery.find(params[:bakery_id])
  end
end