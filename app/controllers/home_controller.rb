class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @bakeries = Bakery.all
  end
end
