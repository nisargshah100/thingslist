class CategoriesController < ApplicationController

  def show
    cities = @city.find_closest(30).only(:_id).limit(100).map(&:_id)
    cities << @city._id

    @category = Category.find_by_slug(params[:id]) || raise_404
    @ads = @category.ads
            .where(:city_id.in => cities)
            .order_by([:created_at, :desc])
            
    @ads = @ads.fulltext_search(params[:q]) unless params[:q].blank?
    @ads = @ads.group_by { |x| x.created_at.to_date }
  end

end
