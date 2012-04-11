class Api::CategoriesController < Api::ApiController

  def index
    categories = Category.only(:name).children()

    respond_to do |f|
      f.json { render :json => categories }
      f.xml { render :xml => categories }
    end
  end

end
