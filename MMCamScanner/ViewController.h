//
//  ViewController.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleAnimation.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cameraBut;
@property (weak, nonatomic) IBOutlet UIButton *pickerBut;

@property (strong ,nonatomic) UIImagePickerController *invokeCamera;
- (IBAction)cameraAction:(id)sender;
- (IBAction)pickerAction:(id)sender;

@end

