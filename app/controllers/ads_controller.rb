class AdsController < ApplicationController
  
  def new
    cid = params[:cid] || ""
    @category = Category.where(:_id => cid).first

    if @category
      render "templates/#{@category.template}_new", :layout => false
    end
  end

  def create
  end
  
end
