//
//  GestureController.swift
//  GestureController
//
//  Created by Tikam on 01/06/18.
//  Copyright © 2018 Dexati. All rights reserved.
//

import Foundation
import UIKit
@objc protocol gestureControllerDelegate
{
    @objc optional func positionOfCurrentView(view:UIView)
    @objc optional func displayAlertToDelete(tag:Int)
}
class GestureController :UIViewController,UIGestureRecognizerDelegate
{
    var isRotateActive: Bool = true
    var isMoveActve :Bool = true
    var detectLongPress: Bool = true
    var detectDoubleTouch : Bool = true
    var isZoomActive:Bool = true
    var gestureDelegate : gestureControllerDelegate?
    
    func addGesture(baseView:UIView ,tag: Int)
    {
        if(self.isRotateActive)
        {
            let rotateGesture  = UIRotationGestureRecognizer(target: self, action: #selector(self.rotateGesture(_:)))
            baseView.addGestureRecognizer(rotateGesture)
            rotateGesture.delegate = self;
            baseView.isUserInteractionEnabled = true
            baseView.isMultipleTouchEnabled = true
        }
        
        if(self.isMoveActve)
        {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveGesture(_:)))
            baseView.isUserInteractionEnabled = true
            panGesture.delegate = self;
            baseView.addGestureRecognizer(panGesture)
        }
        if(self.isZoomActive)
        {
            let zoomGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomGesture(_:)))
            baseView.isUserInteractionEnabled = true
            zoomGesture.delegate = self;
            baseView.addGestureRecognizer(zoomGesture)
        }
        if(self.detectLongPress)
        {
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressEvent(_:)))
            baseView.isUserInteractionEnabled = true
            longPressGesture.delegate = self;
            baseView.addGestureRecognizer(longPressGesture)
        }
        if(self.detectDoubleTouch)
        {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTouchDetect(_:)))
            baseView.isUserInteractionEnabled = true
            tapGesture.delegate = self;
            tapGesture.numberOfTapsRequired = 2
            baseView.addGestureRecognizer(tapGesture)
            
        }
    }
    
    @objc func moveGesture(_ sender:UIPanGestureRecognizer)
    {
        self.view.bringSubview(toFront: sender.view!)
        let translation = sender.translation(in: self.view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        self.gestureDelegate?.positionOfCurrentView!(view: sender.view!)

    }
    @objc func zoomGesture(_ sender:UIPinchGestureRecognizer)
    {
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        let currentTrans = sender.view?.transform
        imageView.transform = currentTrans!.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }
    @objc func longPressEvent(_ sender:UILongPressGestureRecognizer)
    {
        print("long press active ",sender.view!.tag)
        self.gestureDelegate?.displayAlertToDelete!(tag:sender.view!.tag)
    }
    @objc func doubleTouchDetect(_ sender:UILongPressGestureRecognizer)
    {
        print("doubleTouchDetect ",sender.view!.tag)
    }
    @objc func rotateGesture(_ sender:UIRotationGestureRecognizer) {
            let rotation = sender.rotation
            // var point = rotateGesture.location(in: viewRotate)
            let currentTrans = sender.view?.transform
            let newTrans = currentTrans!.rotated(by: rotation)
            sender.view?.transform = newTrans
            sender.rotation = 0.0
            self.gestureDelegate?.positionOfCurrentView!(view: sender.view!)

    }
}
