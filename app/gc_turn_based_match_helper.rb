class GCTurnBasedMatchHelper

  attr_accessor :userAuthenticated, :presentingViewController, :currentMatch

  def self.sharedInstance
    @@sharedHelper ||= GCTurnBasedMatchHelper.alloc.init
  end

  def initialize
    nc = NSNotificationCenter.defaultCenter
    nc.addObserver self, selector: 'authenticationChanged',
    name: GKPlayerAuthenticationDidChangeNotificationName, object: nil
  end

  def authenticationChanged
    if GKLocalPlayer.localPlayer.isAuthenticated && !userAuthenticated
      NSLog("Authentication changed: player authenticated.")
      @userAuthenticated = true
    elsif !GKLocalPlayer.localPlayer.isAuthenticated && userAuthenticated
      NSLog("Authentication changed: player not authenticated")
      @userAuthenticated = false
    end
  end

  def authenticateLocalUser
    NSLog("Authenticating local user...")
    unless GKLocalPlayer.localPlayer.authenticated?
      GKLocalPlayer.localPlayer.authenticateWithCompletionHandler nil
    else
      NSLog("Already authenticated!")
    end
  end

  def findMatchWithMinPlayers minPlayers, maxPlayers: maxPlayers, viewController: viewController
    @presentingViewController ||= viewController
    request = GKMatchRequest.alloc.init
    request.minPlayers = minPlayers
    request.maxPlayers = maxPlayers
    mmvc = GKTurnBasedMatchmakerViewController.alloc.initWithMatchRequest request
    mmvc.turnBasedMatchmakerDelegate = self
    mmvc.showExistingMatches = true
    presentingViewController.presentModalViewController mmvc, animated: true
  end
  
  def turnBasedMatchmakerViewController viewController, didFindMatch: match
    presentingViewController.dismissModalViewControllerAnimated true
    @currentMatch = match
    firstParticipant = match.participants.first
    if firstParticipant.performSelector(:lastTurnDate)
      NSLog("existing Match")
    else
      NSLog("new Match")
    end
    NSLog("did find match, #{match}")
  end

  def turnBasedMatchmakerViewControllerWasCancelled viewController
    presentingViewController.dismissModalViewControllerAnimated true
    NSLog("has cancelled")
  end

  def turnBasedMatchmakerViewController viewController, didFailWithError: error
    presentingViewController.dismissModalViewControllerAnimated true
    NSLog("Error finding match: #{error.localizedDescription}")
  end

  def turnBasedMatchmakerViewController viewController, playerQuitForMatch: match
    NSLog("playerquitforMatch, #{match}, #{match.currentParticipant}")
  end

end
