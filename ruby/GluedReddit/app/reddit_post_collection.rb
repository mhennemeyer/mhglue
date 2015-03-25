class RedditPostCollection < MHWebService
  def self.resources_url
    "http://www.reddit.com/search.json"
  end
  
  def self.reload_posts(params)
    @posts = parse_resources(getResources(params))
  end
  
  @posts ||= []
  def self.posts
    @posts
  end
  
  def self.parse_resources(data)
    MHJSONParser.parse(data)['data']['children'].map do |dict|
     Post.new(dict['data'])
    end
  end
end

