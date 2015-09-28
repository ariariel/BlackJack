//
//  Player.swift
//  BlackJack
//
//  Created by Ari on 9/18/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation

class Player{
    var name: String
    var coins: Int
    var hand: [Card]
    var noMore: Bool
    var broke: Bool
    
    init(name: String){
        self.name = name
        coins = 100
        hand = []
        // 'noMore' means no more cards
        noMore = false
        // 'broke' means player went over 21
        broke = false
    }
    
    func getName()->String{
        return self.name
    }
    
    func getCoins()->Int{
        return self.coins
    }
    
    func revealCard()->String{
        return (self.hand.first?.getImgName())!
    }
    
    // If the player wants no more cards
    func wantNoMore(){
        self.noMore = true
    }
    
    // If the player can take more cards
    func wantMore()->Bool{
        if (!self.noMore && !isDefinitelyBroke()){
            return true
        }else{
            return false
        }
    }
    
    // If player is done
    func isDone()->Bool{
        if(self.noMore || self.broke){
            return true
        }else{
            return false
        }
    }
    
    func isBroke()->Bool{
        return self.broke
    }
    
    func isDefinitelyBroke()->Bool{
        let totalValue: Int = getHandValue()
        // 'newNum' represents the value that the user can actually see
        let newNum: Int = totalValue - self.hand[0].getValue()
        if(newNum > 20){
            return true
        }else{
            return false
        }
    }
    
    // Get the cumulative value
    func getHandValue()->Int{
        var sum: Int = 0
        for var i = 0; i < hand.count; ++i{
            sum += hand[i].getValue()
        }
        return sum
    }
    
    // Get the size of your hand
    func getHandCount()->Int{
        return hand.count
    }
    
    // Add Card to your hand
    func addCard(newCard: Card){
        hand.append(newCard)
        if(getHandValue() > 21){
            self.broke = true
        }
    }
    
    // Betting function that returns the true value
    // that was bet. (ie. A player might accidently bet
    // more than he/she actually has, so it defaults to 'All in'
    func bet(coins: Int)->Int{
        if coins <= self.coins{
            self.coins -= coins
            return coins
        }else{
            // temp represents 'all in' option
            let temp = self.coins
            self.coins = 0
            return temp
        }
    }
    
    func wins(coins: Int){
        self.coins += coins
    }
    
    func resetHand(){
        self.hand = []
        self.noMore = false
        self.broke = false
    }
    
}