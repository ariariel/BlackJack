//
//  Deck.swift
//  BlackJack
//
//  Created by Ari on 9/18/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation


class Deck{
    var cards: [Card] = [];
    var deckPointer: Int;
    var suites: [String] = ["spades","clubs","hearts","diamonds"];
    
    init(){
        // Initializatiton
        deckPointer = 51
        
        // Form Deck
        formDeck()
        
        // Shuffle Deck
        shuffleDeck()
    }
    
    // To deal card, get the last card
    func dealCard()->Card{
        let tempCard: Card = cards[cards.count-1]
        cards.removeLast()
        return tempCard
    }
    
    // Creates 52 cards
    func formDeck(){
        for var i = 0; i < 4; ++i{
            for var j = 0; j < 13; ++j{
                cards.append(Card(setSuite: suites[i],setCardNumber:j + 1))
            }
        }
    }
    
    // Shuffles the deck
    func shuffleDeck(){
        self.cards = cards.shuffle()
    }
    
    
    
}