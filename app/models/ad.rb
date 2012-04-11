class Ad
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to :city
  belongs_to :category
  
  field :title
  field :description

  def to_s
    title
  end
end
