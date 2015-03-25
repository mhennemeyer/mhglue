class MHServiceClient
  
  def self.register(key, &block)
    @register ||= {}
    @register[key] = block
  end
  
  def self.loadWithKey(key, params:params)
    block = @register[key]
    Dispatch::Queue.concurrent.async do 
      block.call(params)
      Dispatch::Queue.main.sync do 
        @update_blocks[key].each(&:call)
      end
    end
  end
  
  def self.onUpdate(key, &block)
    @update_blocks ||= {}
    @update_blocks[key] ||= []
    @update_blocks[key] << block
  end
end