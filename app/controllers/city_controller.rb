class CityController < ApplicationController
  
  def index
  end

  def show
    @city = City.find_by_slug(params[:id]) || raise_404
    cache_city(@city)

    @categories = Category.parents()
  end
end
