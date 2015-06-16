//
//  MMCameraPickerController.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraFocusSquare.h"
#import "CropViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+fixOrientation.h"
#import "UIColor+HexRepresentation.h"
@class MMCameraPickerController;
@protocol MMCameraDelegate <NSObject>

-(void)didFinishCaptureImage:(UIImage *)capturedImage withMMCam:(MMCameraPickerController*)cropcam;
-(void)authorizationStatus:(BOOL)status;

@end
@interface MMCameraPickerController : UIViewController{
    BOOL toogleFlash,toggleCamera;
    
}
@property (weak, nonatomic) IBOutlet UIButton *backBut;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *flashBut;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraBut;
@property (weak, nonatomic) IBOutlet UIButton *retakeBut;
@property (weak, nonatomic) IBOutlet UIButton *captureBut;
@property (weak, nonatomic) IBOutlet UIButton *doneBut;
@property (weak, nonatomic) id <MMCameraDelegate> camdelegate;
- (IBAction)capturePhoto:(id)sender;
- (IBAction)retakeAction:(id)sender;
- (IBAction)doneAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;
- (IBAction)zoomsliderAction:(id)sender;
- (IBAction)flashAction:(id)sender;
- (IBAction)switchCameraAction:(id)sender;
- (IBAction)backToParent:(id)sender;


//close completion block
- (void) closeWithCompletion:(void (^)(void))completion;
@end
