class CityController < ApplicationController
  
  def index
  end

  def show
    @city = City.find_by_slug(params[:id]) || raise_404
    cache_city(@city)

    @categories = Category.parents()
  end

  def search
    @query = params[:q]
    @ads = Ad.fulltext_search(@query).group_by { |x| x.created_at.to_date }
  end

end
