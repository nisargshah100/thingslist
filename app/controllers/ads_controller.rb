class AdsController < ApplicationController
  before_filter :authenticate_user!

  def new
    cid = params[:cid] || ""
    @category = Category.where(:_id => cid).first

    if @category
      @ad = Ad.new
      render "templates/#{@category.template}_new", :layout => false
    end
  end

  def create
    render :json => Ad.new(params[:ad])
  end

  
end
