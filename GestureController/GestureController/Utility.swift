//
//  Utility.swift
//  GestureController
//
//  Created by Tikam on 04/06/18.
//  Copyright © 2018 Dexati. All rights reserved.
//
import UIKit
import Foundation

class Utility: NSObject {

    static func displayAlert(title:String, description:String, buttonTitles:Array<Any>,
                             selectedImage:Int, delegate:ViewController)
{
    let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
    var counter  = 0;
    
    for buttonName in buttonTitles
    {
        print("buttonTitle ", buttonName)
        counter = counter + 1
        let action0 = UIAlertAction(title: buttonName as? String,
                                    style: UIAlertActionStyle.default,
                                    handler: delegate.handleConfirmPressed(listINeed: buttonName as! String, tag:counter, imageTag:selectedImage))
        alertController.addAction(action0);
    }
    delegate.present(alertController, animated: true, completion: nil)
}
}
