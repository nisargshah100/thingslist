class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :closest_city

  private

  def ipaddress
    ip = request.remote_ip
    ip = "68.48.152.219" if ip.blank? or ip == "127.0.0.1"
    ip
  end

  def closest_city
    geo = Geocoder.search(ipaddress).first
    @city = City.find_closest([geo.longitude, geo.latitude]) if geo
  end

end