class AdsController < ApplicationController
  before_filter :authenticate_user!, :except => :show

  def new
    cid = params[:cid] || ""
    @category = Category.where(:_id => cid).first

    if @category
      @ad = Ad.new
      render "templates/new/#{@category.template}", :layout => false
    end
  end

  def show
    @ad = Ad.find(params[:id])
    render "templates/view/#{@ad.category.template}"
  end
  
end
