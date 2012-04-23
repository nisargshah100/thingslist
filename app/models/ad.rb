class FbValidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value or value.facebook_valid == false
      record.errors[attribute] << (options[:message] || "is not valid")
    end
  end
end

class Ad
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::FullTextSearch

  @@QUALITY_OPTIONS = ['new','used', 'refurbished', 'not working']
  cattr_reader :QUALITY_OPTIONS

  belongs_to :city
  belongs_to :category
  belongs_to :user
  
  field :title
  field :description
  field :price
  field :quality

  validates :title, :presence => true
  validates :description, :presence => true
  validates :user, :presence => true, :fb_valid => true
  validates :city, :presence => true
  validates :quality, :inclusion => { 
                        :in => Ad.QUALITY_OPTIONS, 
                        :allow_blank => true 
                      }

  fulltext_search_in :title, :description

  def price
    price = Money.new(read_attribute(:price) || 0)
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
