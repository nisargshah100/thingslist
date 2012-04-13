class CityController < ApplicationController
  
  def index
  end

  def show
    @categories = Category.parents()
  end
end
