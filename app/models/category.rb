class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  
  has_many :children, :class_name => 'Category', :inverse_of => :parent
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children
  has_many :ads

  field :name

  def self.parents()
    Category.where(:parent_id => nil)
  end

  def self.children()
    Category.all() - self.parents()
  end

  def to_s
    name
  end

end