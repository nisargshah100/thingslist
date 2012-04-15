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
end
