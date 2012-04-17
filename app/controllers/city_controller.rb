class CityController < ApplicationController
  
  def index
  end

  def show
    c = City.find_by_slug(params[:id]) || raise_404
    cookies[:city] = c.id

    @categories = Category.parents()
  end
end
