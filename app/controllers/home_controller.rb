class HomeController < ApplicationController

  def index
    redirect_to city_path(@city)
  end

  def redirect
    @url = params[:url] || raise_404
  end

  def fbobject
    render 'fbobject', :layout => nil
  end

end
