class Ad
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::FullTextSearch
  
  belongs_to :city
  belongs_to :category
  belongs_to :user
  
  field :title
  field :description
  field :price

  validates :title, :presence => true
  validates :description, :presence => true
  validates :city, :presence => true

  fulltext_search_in :title, :description

  def price
    Money.new(read_attribute(:price) || 0)
  end

  def price=(price)
    write_attribute(:price, Money.parse(price).cents)
  end

  def to_s
    title
  end

  def distance(city, unit = :mi)
    self.city.find_distance(city, unit).round(2)
  end

  def self.within(city, dist, unit = :mi)
    cities = city.find_closest(dist, unit).only(:_id).limit(100).map(&:_id)
    cities << city._id

    Ad.where(:city_id.in => cities)
  end

end
