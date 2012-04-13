class HomeController < ApplicationController
  
  def index
    redirect_to city_path(@city)
  end

end
