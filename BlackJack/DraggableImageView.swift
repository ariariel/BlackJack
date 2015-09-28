//
//  DraggableImageView.swift
//  BlackJack
//
//  Created by Ari on 9/20/15.
//  Copyright © 2015 Ari. All rights reserved.
//

import Foundation
import UIKit

class DraggableImageView : UIImageView{
    var startPosition:CGPoint?
    var defaultPosition: CGPoint?
    var droppedPosition: CGPoint?
    override init( image: UIImage!){
        super.init(image: image)
        self.userInteractionEnabled = true
        addGestureRecognizer(UIPanGestureRecognizer(target: self,action:"handlePan:"))
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height:3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.userInteractionEnabled = true
        let nizer : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self,action:"handlePan:")
        addGestureRecognizer(nizer)
        defaultPosition = CGPoint(x: 202.5, y: self.center.y-self.frame.size.height/4)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height:3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
    }
    
    func handlePan(nizer:UIPanGestureRecognizer!){
        if nizer.state == UIGestureRecognizerState.Began{
            let locationInView = nizer.locationInView(superview)
            startPosition = CGPoint(x: locationInView.x - center.x, y:locationInView.y - center.y)
            layer.shadowOffset = CGSize(width: 0, height:20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            return
        }
        if nizer.state == UIGestureRecognizerState.Ended{
            droppedPosition = self.center
            self.center = defaultPosition!
            startPosition = nil
            layer.shadowOffset = CGSize(width: 0, height:3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            return
        }
        let locationInView = nizer.locationInView(superview)
        
        UIView.animateWithDuration(0.05){
            self.center = CGPoint(x:locationInView.x - self.startPosition!.x,y:locationInView.y - self.startPosition!.y)
        }
    }
}