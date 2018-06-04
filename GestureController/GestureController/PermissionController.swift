//
//  PermissionController.swift
//  GestureController
//
//  Created by Tikam on 31/05/18.
//  Copyright © 2018 Dexati. All rights reserved.
//

import Foundation
import Photos
import AVFoundation

protocol permissionControllerDelegate {
    func grantCameraPermission()
    func grantGalleryPermission()
    func errorOnPermission(errorMsg:String , errorCode:AVAuthorizationStatus)
}
 class PermissionController: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     let SettingsMessageGallery = "Please go to Privacy and change the settings to use Gallery"
     let SettingsMessageCamera = "Please go to Privacy and change the settings to use Camera"
     let NoCameraMSG = "Device has no camera"
    
    var permissionDelegate : permissionControllerDelegate?

    func aksForGalleryPermission()
    {
        let photosStatus = PHPhotoLibrary.authorizationStatus()
        if(PHAuthorizationStatus.notDetermined == photosStatus)
        {
            PHPhotoLibrary.requestAuthorization(
                {
                status in
                if status == .authorized{
                    self.permissionDelegate?.grantGalleryPermission();
                } else {
                    self.permissionDelegate?.errorOnPermission(errorMsg:self.SettingsMessageGallery, errorCode: AVAuthorizationStatus.denied)
                    }
            })
        }
        else if(PHAuthorizationStatus.denied == photosStatus
            || PHAuthorizationStatus.restricted == photosStatus )
        {
            self.permissionDelegate?.errorOnPermission(errorMsg:self.SettingsMessageGallery, errorCode: AVAuthorizationStatus.denied)
        }
        else if (PHAuthorizationStatus.authorized == photosStatus)
        {
            self.permissionDelegate?.grantGalleryPermission();
        }
    }

    func askForCameraPermission()
  {
    if(!UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
    {
       self.permissionDelegate?.errorOnPermission(errorMsg:self.NoCameraMSG, errorCode: AVAuthorizationStatus.denied)
        return;
    }
    let authorizationStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    if(AVAuthorizationStatus.notDetermined == authorizationStatus)
    {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.permissionDelegate?.grantCameraPermission();

            } else {
                self.permissionDelegate?.errorOnPermission(errorMsg:self.SettingsMessageCamera, errorCode: AVAuthorizationStatus.denied)
            }
        }
    }
    else if(AVAuthorizationStatus.denied == authorizationStatus
        || AVAuthorizationStatus.restricted == authorizationStatus )
    {
        self.permissionDelegate?.errorOnPermission(errorMsg:self.SettingsMessageCamera, errorCode: AVAuthorizationStatus.denied)

    }
    else if (AVAuthorizationStatus.authorized == authorizationStatus)
    {
        self.permissionDelegate?.grantCameraPermission();
    }
  }
}

