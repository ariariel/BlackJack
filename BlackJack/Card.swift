//
//  Card.swift
//  BlackJack
//
//  Created by Ari on 9/18/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation

class Card{
    var suite: String
    var cardNumber: Int
    var value: Int
    
    init(setSuite: String, setCardNumber: Int){
        // Initializatiton
        suite = setSuite
        cardNumber = setCardNumber
        
        // This takes the card number (1-13) and assigns them respective values
        // TODO: Ace also has the option of having a value of 11
        if cardNumber < 11{
            value = cardNumber
        }else{
            value = 10
        }
    }
    
    // Get Methods
    func getValue()->Int{
        return value;
    }
    func getSuite()->String{
        return suite;
    }
    // Method to construct string of image name
    func getImgName()->String{
        var imgName: String = ""
        if cardNumber != 1 && cardNumber < 11{
            imgName += String(cardNumber)
        }else{
            switch cardNumber{
                case 1:
                    imgName += "ace"
                case 11:
                    imgName += "jack"
                case 12:
                    imgName += "queen"
                case 13:
                    imgName += "king"
                default:
                    imgName += ""
            }
        }
        imgName += "_of_" + suite
        return imgName
    }
}
