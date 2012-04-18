class Ad
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :city
  belongs_to :category
  belongs_to :user
  
  field :title
  field :description

  validates :title, :presence => true
  validates :description, :presence => true
  validates :city, :presence => true

  def to_s
    title
  end

  def distance(city, unit = :mi)
    self.city.find_distance(city, unit).round(2)
  end

end
