class CityController < ApplicationController
  
  def index
  end

  def show
    @city = City.find_by_slug(params[:id]) || raise_404
    cache_city(@city)

    @categories = Category.parents()
  end

  # Need to make sure that its limited by geospatial distance
  def search
    @query = params[:q]
    @ads = Ad.within(@city, 30)
    @ads = @ads.fulltext_search(@query).group_by { |x| x.created_at.to_date }
  end

end
