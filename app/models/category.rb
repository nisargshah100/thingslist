class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  has_many :children, :class_name => 'Category', :inverse_of => :parent
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children
  has_many :ads

  field :name
  slug :to_s

  def self.parents()
    Category.where(:parent_id => nil)
  end

  def self.children()
    Category.all() - self.parents()
  end

  def to_s
    "#{name} #{parent.name if parent}"
  end

  def serialize
    s = {
      :id => id,
      :name => name
    }
    s[:parent] = parent.name if parent
    s
  end

end
