//
//  ViewController.swift
//  BlackJack
//
//  Created by Ari on 9/18/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate {
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var player1_hand: UIStackView!
    @IBOutlet weak var player2_hand: UIStackView!
    @IBOutlet weak var next_card: UIImageView!
    @IBOutlet weak var player1_name_label: UILabel!
    @IBOutlet weak var player2_name_label: UILabel!
    @IBOutlet weak var player1_coin_label: UILabel!
    @IBOutlet weak var player2_coin_label: UILabel!
    @IBOutlet weak var totalBet_label: UILabel!
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bet_input: UITextField!
    @IBOutlet weak var bet_btn: UIButton!
    @IBOutlet weak var done_btn: UIButton!
    @IBOutlet weak var player1_card1: UIImageView!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var player1_card2: UIImageView!
    @IBOutlet weak var player2_card1: UIImageView!
    @IBOutlet weak var player2_card2: UIImageView!
    @IBOutlet weak var player1_brokeLabel: UILabel!
    @IBOutlet weak var player2_brokeLabel: UILabel!
    @IBOutlet weak var newRoundBtn: UIButton!
    var player1_name: String!
    @IBOutlet weak var minBetLabel: UILabel!
    var player2_name: String!
    var player1: Player!
    var player2: Player!
    var currentPlayer: Player!
    var opposingPlayer: Player!
    var game: Blackjack!
    var card_constraints: [NSLayoutConstraint]!
    var defaultPosition: CGPoint!
    var betEnable: Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the players' name labels
        player1_name_label.text = player1_name!
        player2_name_label.text = player2_name!
        
        // Initialize players
        player1 = Player(name: player1_name)
        player2 = Player(name: player2_name)
        
        // Instantiate Game
        game = Blackjack(player1: player1!, player2: player2!)
        
        // Point to the current player and update label
        currentPlayer = game.getPlayer1()
        opposingPlayer = game.getPlayer2()
        currentPlayerLabel.text = currentPlayer?.getName()
        
        // Initialize card constraints
        card_constraints = []
        
        
        // Update labels and set rules for inputs
        updateCoinLabels()
        done_btn.enabled = true
        bet_btn.enabled = false
        bet_input.delegate = self
        betEnable = false
        
        // Starting the game!
        
        // Start with 2 cards per player
        player1_card1.image = UIImage(named: game.dealTo(1))
        addImageViewToStack(player1_card1, stack: player1_hand)
        
        player1_card2.image = UIImage(named: game.dealTo(1))
        addImageViewToStack(player1_card2, stack: player1_hand)
        
        player2_card1.image = UIImage(named: game.dealTo(2))
        addImageViewToStack(player2_card1, stack: player2_hand)
        
        player2_card2.image = UIImage(named: game.dealTo(2))
        addImageViewToStack(player2_card2, stack: player2_hand)
        
        print(String(player1_hand.subviews.count))
        print(String(player2_hand.subviews.count))
        
    
    }
    
    // This changes turns
    func nextTurn(){
        print("opposing player, "+opposingPlayer.getName()+" , wants more: "+String(opposingPlayer.wantMore()))
        if opposingPlayer!.wantMore(){
            // temporarily store current player
            let temp: Player = currentPlayer!
            // set new value
            currentPlayer = opposingPlayer
            opposingPlayer = temp
        }
        // New turn, tell the user
        currentPlayerLabel.text = (currentPlayer?.getName())! + "!"
        
        // Check to see if the player has at least 2 cards before he holds
        if currentPlayer?.getHandCount() >= 2{
            done_btn.enabled = true
        }else{
            done_btn.enabled = false
        }
    }

    func endRound(){
        // END OF ROUND
        nextRoundButton.hidden = false
        
        // Reveal the hidden cards to the players
        player1_card1.image = UIImage(named: game.getPlayer1().revealCard())
        player2_card1.image = UIImage(named: game.getPlayer2().revealCard())
        
        // set BROKE flag (let the user know that they broke, in case they didnt know already)
        if game.getPlayer1().isBroke(){
            player1_brokeLabel.text = "BROKE"
        }else if game.getPlayer2().isBroke(){
            player2_brokeLabel.text = "BROKE"
        }
        
        // Save award amount
        let award: Int = game.getCurrentBet()
        
        // The round is over, compare hands and pay winner
        var winner: [Player] = game.compareHands()
        
        // After the player(s) have been paid out, refresh labels
        updateCoinLabels()
        
        
        // Display results by using and Alert message to the user
        //var alert: UIAlertController!
        // If it's a tie, there are two winners
        if(winner.count == 2){
//            alert = UIAlertController(title: "It's a tie!", message: "You each won "+String(award/2) + " coins!", preferredStyle: .Alert)
//            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                // ...
//                self.setupNextRound()
//            }
//            alert.addAction(OKAction)
//            self.presentViewController(alert, animated: true) {
//            }
            player1_coin_label.textColor = UIColor.blueColor()
            player2_coin_label.textColor = UIColor.blueColor()
            currentPlayerLabel.text = "a tie!"
            messageLabel.hidden = true
        }
        // Otherwise, only one may be the winner
        else if(winner.count == 1){
//            alert = UIAlertController(title: "Congratulations, "+winner[0].getName()+"!", message: "You have won "+String(award)+" coins!", preferredStyle: .Alert)
//            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
//                // ...
//                self.setupNextRound()
//            }
//            alert.addAction(OKAction)
//            self.presentViewController(alert, animated: true){
//            }
            messageLabel.text = "You won,"
            if winner[0] === game.getPlayer1(){
                player1_coin_label.textColor = UIColor.blueColor()
                player2_coin_label.textColor = UIColor.redColor()
                currentPlayerLabel.text = game.getPlayer1().getName()
            }else if winner[0] === game.getPlayer2(){
                player2_coin_label.textColor = UIColor.blueColor()
                player1_coin_label.textColor = UIColor.redColor()
                currentPlayerLabel.text = game.getPlayer2().getName()
            }
        }
        
        
    }
    
    // Setup
    func setupNextRound(){
        print("Setting up next round!")
        // Reset players hands and get new deck
        game.collectCards()
        
        // Clear Card views
        player1_hand.subviews.forEach({ $0.removeFromSuperview() })
        player2_hand.subviews.forEach({ $0.removeFromSuperview() })
        
        // Hide the BROKE flags
        player1_brokeLabel.text = ""
        player2_brokeLabel.text = ""
        
        game.setMinBet(5)
        // Reset bet text field
        bet_input.text = String(game.getMinBet())
        
        // Start with 2 cards per player
        player1_card1.image = UIImage(named: game.dealTo(1))
        addImageViewToStack(player1_card1, stack: player1_hand)
//
        addImageToStack(game.dealTo(1), stack: player1_hand)
//
        player2_card1.image = UIImage(named: game.dealTo(2))
        addImageViewToStack(player2_card1, stack: player2_hand)
//
        addImageToStack(game.dealTo(2), stack: player2_hand)
        messageLabel.text = "It's your turn,"
        messageLabel.hidden = false
        currentPlayerLabel.text = currentPlayer.getName()
    }
    
    // Update coin labels
    func updateCoinLabels(){
        // Set player's coin amount
        player1_coin_label.text = "Coins: " + String(game.getPlayer1().getCoins())
        player2_coin_label.text = "Coins: " + String(game.getPlayer2().getCoins())
        // Set minimum bet
        minBetLabel.text = String(game.getMinBet())+" Coins"
        // Set total bet label
        totalBet_label.text = String(game.getCurrentBet()) + " Coins"
        // Set bet inpput field to minimum bet
        bet_input.text = String(game.getMinBet())
    }
    
    // Only numeric textfield
    func textField(bet_input: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Find out what the text field will be after adding the current edit
        let text = (bet_input.text as! NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if let temp = Int(text) {
            if temp >= game.minBet{
                // Text field converted to an Int
                betEnable = true
                bet_btn.enabled = true
            }else{
                betEnable = false
                bet_btn.enabled = false
            }
        } else {
            // Text field is not an Int
            betEnable = false
            bet_btn.enabled = false
        }
        
        // Return true so the text field will be changed
        return true
    }
    

    
    func getConstraints(newImage : UIImageView)->[NSLayoutConstraint]{
        card_constraints = []
        card_constraints.append(NSLayoutConstraint(item: newImage,
            attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 115))
        card_constraints.append(NSLayoutConstraint(item: newImage,
            attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil,
            attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1,
            constant: 159))
        return card_constraints
    }
    
    
    // handle pan gesture
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                y:view.center.y + translation.y)
            
            if(recognizer.state == UIGestureRecognizerState.Began){
                // Store the starting position
                defaultPosition = view.center
                view.layer.shadowOffset = CGSize(width: 0, height:20)
                view.layer.shadowOpacity = 0.3
                view.layer.shadowRadius = 6
                
            }
            // THE CLICK WAS RELEASED AND THE CARD IS NO LONGER DRAGGING
            if(recognizer.state == UIGestureRecognizerState.Ended){
                // First make sure that the bet text field is valid before move is made
                if(bet_input.text != ""){
                    if ( CGRectContainsPoint(player1_hand.frame, view.center) ) {
                        // Card was dropped in player1's hand
                        print("Dropped in player 1 hand")
                        if currentPlayer?.getName() == game.getPlayer1().getName(){
                            // if move is in-turn, add card
                            let imgName: String = game.dealTo(1)
                            addImageToStack(imgName, stack: player1_hand)
                            print(imgName)
                            
                            if currentPlayer!.isDefinitelyBroke(){
                                player1_brokeLabel.text = "BROKE"
                            }
                            // If there is a bet
                            if(bet_input.text != ""){
                                game.bets(currentPlayer!, amount: Int(bet_input.text!)!)
                                updateCoinLabels()
                            }
                            // if the opposition is also broke, end round
                            if !opposingPlayer!.wantMore() && !currentPlayer.wantMore(){
                                endRound()
                            }else{
                                // Next turn
                                nextTurn()
                            }
                        }
                    }else if( CGRectContainsPoint(player2_hand.frame, view.center) ) {
                        // Card was dropped in player2's hand
                        print("Dropped in player 2 hand")
                        if currentPlayer?.getName() == player2?.getName(){
                            // if move is in-turn
                            let imgName: String = game.dealTo(2)
                            addImageToStack(imgName, stack: player2_hand)
                            print(imgName)
                            if currentPlayer!.isDefinitelyBroke(){
                                player2_brokeLabel.text = "BROKE"
                            }
                            // If there is a bet
//                            if(bet_input.text != ""){
//                                game.bets(currentPlayer!, amount: Int(bet_input.text!)!)
//                                updateCoinLabels()
//                            }
                            // if the opposition is also broke, end round
                            if !opposingPlayer!.wantMore() && !currentPlayer.wantMore(){
                                endRound()
                            }else{
                                // Next turn
                                nextTurn()
                            }
                        }
                    }

                }
                
                
                // Restore the location
                view.center = defaultPosition
                
               
                
            }
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
    }
    
    
    // Helper method to put an ImageView in the StackView
    func addImageToStack(imageName: String, stack: UIStackView){
        let newImage: UIImageView = UIImageView(image: UIImage(named: imageName))
        stack.addArrangedSubview(newImage)
        newImage.addConstraints(getConstraints(newImage))
    }
    
    // Helper method to put an ImageView in the StackView
    func addImageViewToStack(imageView: UIImageView, stack: UIStackView){
        stack.addArrangedSubview(imageView)
        imageView.addConstraints(getConstraints(imageView))
    }
    
    @IBAction func initiateNextRound(sender: AnyObject) {
        self.setupNextRound()
        nextRoundButton.hidden = true
    }
    
    
    // The user has decided to stop taking cards
    @IBAction func noMoreCards(sender: AnyObject) {
        currentPlayer.wantNoMore()
        if currentPlayer === game.getPlayer1(){
            player1_name_label.textColor = UIColor.greenColor()
        }else{
            player2_name_label.textColor = UIColor.greenColor()
        }
        if opposingPlayer!.wantMore(){
            // CONTINUE
            nextTurn()
        }else{
            endRound()
            
        }
    }
    @IBAction func betBtnPressed(sender: AnyObject) {
        game.bets(currentPlayer!, amount: Int(bet_input.text!)!)
        updateCoinLabels()
        bet_input.text = "0"
    }
    
    @IBAction func doneBtnPressed(sender: AnyObject) {
        nextTurn()
    }
    //Bet placed by current player
//    @IBAction func placeBet(sender: AnyObject) {
//        if(!opposingPlayer!.isDone()){
//            game.bets(currentPlayer!, amount: Int(bet_input.text!)!)
//            updateCoinLabels()
//        }
//        nextTurn()
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

