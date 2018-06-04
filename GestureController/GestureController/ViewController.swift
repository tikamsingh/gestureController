//
//  ViewController.swift
//  GestureController
//
//  Created by Tikam on 31/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController,permissionControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,gestureControllerDelegate {
   
    
    
    @IBOutlet weak var baseImageView: UIImageView!

    var permissionController: PermissionController?
    var imagePicker :UIImagePickerController?
    var gestureController : GestureController?
    var tagCounter :Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tagCounter = 0;
        permissionController = PermissionController()
        permissionController?.permissionDelegate = self;
        gestureController =  GestureController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    
    @IBAction func openCamera(_ sender: Any) {
        permissionController?.askForCameraPermission();
    }
    @IBAction func openGallery(_ sender: Any) {
        permissionController?.aksForGalleryPermission();
    }
    
    func errorOnPermission(errorMsg: String, errorCode: AVAuthorizationStatus) {
        print("errorOnPermission",errorMsg);
        let alert = UIAlertController(title: "Sorry", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            
            print("action",action.title as Any);
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    func grantCameraPermission() {
        print("camera granted")
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = UIImagePickerControllerSourceType.camera;
        imagePicker?.allowsEditing = false;
        self.present(imagePicker!, animated: true, completion: nil)
    }
    
    func grantGalleryPermission() {
        print("Gallery granted")
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        imagePicker?.allowsEditing = false;
        self.present(imagePicker!, animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancel")
        self.dismiss(animated: true, completion: nil);
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            addGestureInAddedImage(image: pickedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    func addGestureInAddedImage(image:UIImage) {
        tagCounter = tagCounter! + 1;
        let imageView = UIImageView(image: image)
        imageView.tag = tagCounter!;
        imageView.contentMode = .scaleAspectFit
        imageView.frame =  CGRect(x: 100, y: 100, width: 200, height: 200)
        baseImageView.addSubview(imageView)
        gestureController?.isMoveActve = true;
        gestureController?.gestureDelegate =  self;
        gestureController?.addGesture(baseView: imageView, tag: tagCounter!)
        
    }
    func handleConfirmPressed(listINeed:String, tag :Int , imageTag:Int) -> (_ alertAction:UIAlertAction) -> () {
        return { alertAction in
            print("listINeed: \(listINeed)",tag);
            if(tag == 1)
            {
                for view in self.baseImageView.subviews
                {
                    if(view.tag == imageTag)
                    {
                        view.removeFromSuperview();
                    }
                }
            }
        }
    }

func displayAlertToDelete(tag:Int)
{

    Utility.displayAlert(title:"Name", description: "Want to delete", buttonTitles: ["ok","cancel"],selectedImage: tag, delegate: self)
}
func positionOfCurrentView(view: UIView) {
        print("position ",view.frame)
    }
}
