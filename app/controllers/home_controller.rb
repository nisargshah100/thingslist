class HomeController < ApplicationController
  
  def index
    redirect_to city_path(closest_city)
  end

end
