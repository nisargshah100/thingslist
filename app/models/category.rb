class Category
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug
  
  has_many :children, :class_name => 'Category', :inverse_of => :parent
  belongs_to :parent, :class_name => 'Category', :inverse_of => :children
  has_many :ads

  field :name
  field :template, :default => 'default'
  slug :to_s

  def self.parents
    Category.where(:parent_id => nil)
  end

  def self.children
    Category.all() - self.parents()
  end

  def template
    temp = read_attribute(:template)
    temp = self.parent.template if self.parent and temp == 'default'
    temp
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
