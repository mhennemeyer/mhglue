class MHWebService
  
  def self.get(url)
    error_ptr = Pointer.new(:object)
    data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
    unless data
      raise error_ptr[0]
    end
    MHCache.set(url, data)
    
    NSLog("getUrl: #{url}")
    data
  end
  
  def self.getResources(params)
    url = url_with_params(params)
    MHCache.get(url) or get(url)
  end
  
  def self.url_with_params(params)
    url = self.resources_url + "?"
    params.each do |name, value|
      url += "#{name}=#{value}&"
    end
    url
  end
end

class MHJSONParser
  def self.parse(data)
    error_ptr = Pointer.new(:object)
    json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
    unless json
      raise error_ptr[0]
    end
    json
  end
end

class MHCache
  
  attr_accessor :data
  attr_accessor :key
  attr_accessor :date
  
  def self.set(key, data)
    cached_data = new(key, data)
    cached_data.save
  end
  
  def self.get(key)
    @cached_data_objects ||= {}
    cached_data = @cached_data_objects[key]
    NSLog("getUrl from chache: #{key}\n#{cached_data}")
    cached_data and cached_data.data
  end
  
  def self.add_to_cache(cached_data)
    @cached_data_objects ||= {}
    @cached_data_objects[cached_data.key] = cached_data
  end
  
  def initialize(key, data)
    self.data = data
    self.key = key
    self.date = NSDate.date
  end
  
  def save
    MHCache.add_to_cache(self)
  end
  
end