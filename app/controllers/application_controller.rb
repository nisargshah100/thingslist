class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :closest_city

  def raise_404
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def ipaddress
    ip = request.remote_ip
    ip = "68.48.152.219" if ip.blank? or ip == "127.0.0.1"
    ip
  end

  def closest_city
    if cached_city.blank?
      geo = Geocoder.search(ipaddress).first
      @city = City.find_closest([geo.longitude, geo.latitude]) if geo
      cache_city(@city)
    else
      @city = City.find(@city_id)
    end
  end

  # Used for caching the city so that subsequent requests dont
  # repeat geospatial call

  def cached_city
    @city_id ||= cookies[:city]
  end

  def cache_city(city)
    cookies[:city] = @city.id if city
  end

end