class AppDelegate
  def application application, didFinishLaunchingWithOptions: launchOptions
    application.setStatusBarStyle UIStatusBarStyleBlackOpaque
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds).tap do |win|
      win.rootViewController = ViewController.alloc.initWithNibName(nil, bundle: nil)
      win.makeKeyAndVisible
    end
    GCTurnBasedMatchHelper.sharedInstance.authenticateLocalUser
    true
  end
end
