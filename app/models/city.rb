class City
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Spacial::Document
  include Mongoid::Slug
  include Mongoid::FullTextSearch

  belongs_to :state
  has_many :ads

  field :name
  slug :to_s

  # source = { :lng => x, :lat => y }
  # find using [lng, lat] = [x, y]
  field :source, type: Array, spacial: true

  spacial_index :source
  fulltext_search_in

  def geolocation
    geo = Geocoder.search(to_s).first
    if geo
      self.source = { :lat => geo.latitude, :lng => geo.longitude }
    end
  end

  def location
    [source[:lng], source[:lat]]
  end

  def find_closest(distance, unit=:mi)
    City.where(:source.near => 
      { :point => self.location, :max => distance, :unit => unit }).offset(1)
  end

  def find_distance(city, unit=:mi)
    self.distance_from(:source, city.location, { :unit => unit })
  end

  def to_s
    "#{name}, #{state.abbr if state}".downcase
  end

  def self.find_closest(location)
    City.where(:source.near => location).limit(1).first 
  end

  def serialize
    {
      :id => id,
      :name => name,
      :state => state.abbr
    }
  end

end
