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
    if items.respond_to? :each
      value = items.collect do |i|
        if i.respond_to? :serialize
          i.serialize()
        else
          i
        end
      end
    else
      value = items
    end

    respond_to do |f|
      f.xml { render :xml => value }
      f.json { render :json => value }
    end
  end

end