class ViewController < UIViewController
  attr_accessor :characterCountLabel, :inputView, :mainTextController, :textInputField, :gameCenterButton
  
  def viewWillAppear animated
    super
    gameCenterButton.when UIControlEventTouchDown do
      matchRequest
    end
    # gameCenterButton.addTarget self, action: 'matchRequest', forControlEvents: UIControlEventTouchDown
    textInputField.when UIControlEventEditingDidEndOnExit do
      sendTurn
    end
  end
  
  def updateCount sender
  end
  
  def matchRequest
    GCTurnBasedMatchHelper.sharedInstance.findMatchWithMinPlayers 2, maxPlayers: 12, viewController: self
  end
  
  def sendTurn
    currentMatch = GCTurnBasedMatchHelper.sharedInstance.currentMatch
    newStoryString = if textInputField.text.length > 250
      textInputField.text.substringToIndex 249
    else
      textInputField.text
    end
    sendString = NSString.stringWithFormat "#{mainTextController.text} #{newStoryString}"
    data = sendString.dataUsingEncoding NSUTF8StringEncoding
    mainTextController.text = sendString
    currentIndex = currentMatch.participants.index currentMatch.currentParticipant
    nextParticipant = currentMatch.participants[(currentIndex + 1) % currentMatch.participants.count]
    currentMatch.endTurnWithNextParticipant nextParticipant, matchData: data, completionHandler: -> error {
      puts error if error
    }
    NSLog "Send Turn, #{data}, #{nextParticipant}"
    textInputField.text = ""
    characterCountLabel.text = "250"
    characterCountLabel.textColor = UIColor.blackColor
  end
  
end