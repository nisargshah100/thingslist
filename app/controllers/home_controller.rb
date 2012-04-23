class HomeController < ApplicationController

  def index
    redirect_to city_path(@city)
  end

  def redirect
    @url = params[:url] || raise_404
  end

  def fbobject
    raise_404 if params[:key] != FACEBOOK_OBJECT_KEY

    @title = params[:title]
    @description = params[:description]
    @img = params[:img] || "https://s-static.ak.fbcdn.net/images/devsite/attachment_blank.png"
    @url = params[:url] || ""

    render 'fbobject', :layout => nil
  end

end
