class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    registerServices
    
    
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.applicationFrame)
    @window.rootViewController = RedditController.alloc.initWithStyle(UITableViewStylePlain)
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible
    
    
    
    true
  end
  
  def registerServices
    #register :posts
    MHServiceClient.register "posts" do |params|
      RedditPostCollection.reload_posts(params)
    end
  end
end
