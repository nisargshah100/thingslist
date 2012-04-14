class Api::CategoriesController < Api::ApiController
  def index
    categories = Category
    respond_with(categories)
  end

  def parents
    categories = Category.parents()
    respond_with(categories)
  end

  def children
    categories = Category.children()
    respond_with(categories)
  end
end
