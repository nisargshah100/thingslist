class Api::ApiController < ActionController::Base
  respond_to :xml, :json

  def required(*attrs)
    attrs.each do |attr|
      raise "#{attr} is required" if params[attr].blank?
      self.instance_variable_set("@#{attr.to_s}", params[attr])      
    end
  end

  def defaults(attrs)
    attrs.each do |attr,value|
      self.instance_variable_set("@#{attr.to_s}", params[attr] || value)      
    end
  end

  def respond_with(items)
    super(items.collect { |i| i.serialize() })
  end

end