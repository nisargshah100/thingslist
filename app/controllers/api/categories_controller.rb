class Api::CategoriesController < Api::ApiController
  def index
    categories = Category.only(:name)
    respond_with(categories)
  end

  def parents
    categories = Category.only(:name).parents()
    respond_with(categories)
  end

  def children
    categories = Category.only(:name).children()
    respond_with(categories)
  end
end
