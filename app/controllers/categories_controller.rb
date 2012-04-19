class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_slug(params[:id]) || raise_404
    @ads = @category.ads.within(@city, 30).order_by([:created_at, :desc])
    @ads = @ads.fulltext_search(params[:q]) unless params[:q].blank?
    @ads = @ads.group_by { |x| x.created_at.to_date }
  end

end
