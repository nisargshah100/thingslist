class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_slug(params[:id]) || raise_404
    @ads = @category.ads.order_by([:created_at, :desc]).group_by { |x| x.created_at.to_date }
  end

end
