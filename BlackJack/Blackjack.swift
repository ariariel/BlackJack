//
//  Blackjack.swift
//  BlackJack
//
//  Created by Ari on 9/19/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation

class Blackjack{
    var player1: Player
    var player2: Player
    var deck: Deck
    var currentBet: Int
    var leaderBoard: [Player]
    var currentPlayer: Player!
    var minBet: Int
    
    // After acquiring the names of the players, the game is initialized
    init(player1: Player, player2: Player){
        self.player1 = player1
        self.player2 = player2
        self.currentPlayer = player1
        self.deck = Deck()
        leaderBoard = []
        currentBet = 0
        minBet = 5
    }
    
    // Getters
    func getCurrentBet()->Int{
        return self.currentBet
    }
    func getMinBet()->Int{
        return self.minBet
    }
    func getPlayer1()->Player{
        return self.player1
    }
    func getPlayer2()->Player{
        return self.player2
    }
    func setMinBet(minBet: Int){
        self.minBet = minBet
    }
    // PlayerX Gets Paid
    func pay(player: Player, coins: Int){
        player.wins(coins)
        self.currentBet -= coins
    }
    
    // Clears the players' hands
    func collectCards(){
        player1.resetHand()
        player2.resetHand()
        // new deck
        self.deck = Deck()
    }
    
    // When round is over
    func compareHands()->[Player]{
        var winners: [Player] = []
        let award: Int = self.currentBet
        // First check to see if both players broke, if so they tied
        if player1.isDefinitelyBroke() && player2.isDefinitelyBroke(){
            print("There's a tie! The coins are split")
            pay(player1, coins: award/2)
            pay(player2, coins: award/2)
            winners.append(player1)
            winners.append(player2)
        // Then check to see if only one of them broke
        }else if player1.isDefinitelyBroke() && !player2.isDefinitelyBroke(){
            print("Player 2 won!")
            pay(player2,coins: award)
            winners.append(player2)
        }else if player2.isDefinitelyBroke() && !player1.isDefinitelyBroke(){
            print("Player 1 won!")
            pay(player1, coins: award)
            winners.append(player1)
        }else if player1.isBroke(){
            print("Player 2 won!")
            pay(player2,coins: award)
            winners.append(player2)
        }else if player2.isBroke(){
            print("Player 1 won!")
            pay(player1, coins: award)
            winners.append(player1)
        }
        else if player1.getHandValue() == player2.getHandValue(){
            // if the players have the same amount of 'value'
            // check to see who did it with less cards
            if player1.getHandCount() == player2.getHandCount(){
                print("There's a tie! The coins are split")
                pay(player1, coins: award/2)
                pay(player2, coins: award/2)
                winners.append(player1)
                winners.append(player2)
            }else if player1.getHandCount() > player2.getHandCount(){
                print("Player 1 won!")
                pay(player1, coins: award)
                winners.append(player1)
            }else{
                print("Player 2 won!")
                pay(player2,coins: award)
                winners.append(player2)
            }
        }else if player1.getHandValue() == 21{
            print("Player 1 won!")
            pay(player1, coins: award)
            winners.append(player1)
        }else if player2.getHandValue() == 21{
            print("Player 2 won!")
            pay(player2,coins: award)
            winners.append(player2)
        }else if (player1.getHandValue() > player2.getHandValue())&&(player1.getHandValue() < 21){
            print("Player 1 won!")
            pay(player1, coins: award)
            winners.append(player1)
        }else if (player2.getHandValue() > player1.getHandValue())&&(player2.getHandValue() < 21){
            print("Player 2 won!")
            pay(player2, coins: award)
            winners.append(player2)
        }
        return winners
    }
    
        
    // Deal to player, returns image name of card
    func dealTo(player: Int)->String{
        var imgName: String = ""
        let newCard: Card = deck.dealCard()
        
        if player == 1{
            player1.addCard(newCard)
            if(player1.hand.count == 1){
                // if empty, start with face down card
                imgName = "back_of_card"
            }else{
                imgName = newCard.getImgName()
            }
        }else if player == 2{
            player2.addCard(newCard)
            if(player2.hand.count == 1){
                // if empty, start with face down card
                imgName = "back_of_card"
            }else{
                imgName = newCard.getImgName()
            }
        }
        
        return imgName
        
    }
    
    // PlayerX Bets
    func bets(bettingPlayer: Player, amount: Int){
        let realAmount: Int = bettingPlayer.bet(amount)
        if currentBet == 5{
            self.minBet = 5
        }else if realAmount >= minBet{
            self.minBet = realAmount - minBet
        }
        // add bet to the pile
        currentBet += realAmount
    }
    
    
    
}