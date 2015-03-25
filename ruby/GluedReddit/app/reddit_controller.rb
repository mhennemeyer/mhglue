class RedditController < UITableViewController
  def viewDidLoad
    super
    searchBar = UISearchBar.alloc.initWithFrame(CGRectMake(0, 0, self.tableView.frame.size.width, 0))
    searchBar.delegate = self;
    searchBar.showsCancelButton = true;
    searchBar.sizeToFit
    view.tableHeaderView = searchBar
    view.dataSource = view.delegate = self
    
    MHServiceClient.onUpdate "posts" do
      view.reloadData
    end

    searchBar.text = 'funny'
    searchBarSearchButtonClicked(searchBar)
    
  end

  def searchBarSearchButtonClicked(searchBar)
    
    # load with key
    MHServiceClient.loadWithKey "posts", params: { 
      q:searchBar.text.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
    }

    searchBar.resignFirstResponder
  end

  def searchBarCancelButtonClicked(searchBar)
    searchBar.resignFirstResponder
  end
 
  def presentError(error)
    # TODO
    $stderr.puts error.description
  end
 
  def tableView(tableView, numberOfRowsInSection:section)
    RedditPostCollection.posts.size
  end

  def tableView(tableView, heightForRowAtIndexPath:indexPath)
    PostCell.heightForPost(RedditPostCollection.posts[indexPath.row], tableView.frame.size.width)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    post = RedditPostCollection.posts[indexPath.row]
    PostCell.cellForPost(post, inTableView:tableView)
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    post = RedditPostCollection.posts[indexPath.row]
    #PostCell.cellForPost(post, inTableView:tableView)
    NSLog("post: #{post}")
  end
  
  def reloadRowForPost(post)
    row = RedditPostCollection.posts.index(post)
    if row
      view.reloadRowsAtIndexPaths([NSIndexPath.indexPathForRow(row, inSection:0)], withRowAnimation:false)
    end
  end
end
