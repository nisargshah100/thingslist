class State
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :cities

  field :name
  field :abbr

  def to_s
    name
  end

end
