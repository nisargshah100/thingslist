class CategoriesController < ApplicationController

  def show
    @category = Category.find_by_slug(params[:id]) || raise_404
  end

end
