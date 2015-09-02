//
//  MMCameraPickerController.m
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import "MMCameraPickerController.h"
#import <AVFoundation/AVFoundation.h>
#define backgroundHex @"2196f3"
@interface MMCameraPickerController ()<UIGestureRecognizerDelegate>{
    // Measurements
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat topX;
    CGFloat topY;
    
    // Resize Toggles
    BOOL isImageResized;
    BOOL isSaveWaitingForResizedImage;
    BOOL isRotateWaitingForResizedImage;
    
    // Capture Toggle
    BOOL isCapturingImage;
    
    float effectiveScale ,beginGestureScale;
}
// AVFoundation Properties
@property (strong, nonatomic) AVCaptureSession * mySesh;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) AVCaptureDevice * myDevice;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * captureVideoPreviewLayer;

// View Properties
@property (strong, nonatomic) UIView * imageStreamV;
@property (strong, nonatomic) UIImageView * capturedImageV;
@property (strong,nonatomic) CameraFocusSquare *camFocus;

@end

@implementation MMCameraPickerController
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer

{
    
    if ( [gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]] ) {
        
        beginGestureScale = effectiveScale;
        
    }
    
    return YES;
    
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    effectiveScale=1;
    [self setUI];
    [UIView animateWithDuration:0.3 animations:^{
        self.switchCameraBut.alpha=1;
        self.flashBut.alpha=1;
        self.retakeBut.alpha=0;
        self.doneBut.alpha=0;
    }];

    
   
    //Usage
//        __weak __typeof(self)wSelf = self;
//        [self latestPhotoWithCompletion:^(UIImage *photo) {
//            
//            UIImageRenderingMode renderingMode = YES ? UIImageRenderingModeAlwaysOriginal : UIImageRenderingModeAlwaysTemplate;
//            [wSelf.switchCameraBut setImage:[photo imageWithRenderingMode:renderingMode] forState:UIControlStateNormal];
//
//        }];
    
}



- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        // Pre iOS 8 -- No camera auth required.
        [self setUpCameraFoundation];
    }
    else {
        // iOS 8
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                NSLog(@"SC: Not authorized, or restricted");
                break;
            case AVAuthorizationStatusAuthorized:
                [self setUpCameraFoundation];
                break;
            case AVAuthorizationStatusNotDetermined: {
                // not determined
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if(granted){
                        [self setUpCameraFoundation];
                    } else {
                    }
                }];
            }
            default:
                break;
        }
    }
    [self.view bringSubviewToFront:self.bottomView];
    [self.view bringSubviewToFront:self.backBut];
    
}


-(void)setUI{
    
    //Flash But
    self.flashBut.tintColor=[UIColor whiteColor];
    self.flashBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.flashBut.layer.cornerRadius = self.flashBut.frame.size.width / 2;
    self.flashBut.clipsToBounds=YES;
    
    [self.flashBut setImage:[UIImage renderImage:@"CameraFlashOff"] forState:UIControlStateNormal];
    
    //Camera Switch
    self.switchCameraBut.tintColor=[UIColor whiteColor];
    self.switchCameraBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.switchCameraBut.layer.cornerRadius = self.switchCameraBut.frame.size.width / 2;
    self.switchCameraBut.clipsToBounds=YES;
    
    [self.switchCameraBut setImage:[UIImage renderImage:@"Switch"] forState:UIControlStateNormal];
    
    //Done
    self.doneBut.tintColor=[UIColor whiteColor];
    self.doneBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.doneBut.layer.cornerRadius = self.doneBut.frame.size.width / 2;
    self.doneBut.clipsToBounds=YES;
    
    [self.doneBut setImage:[UIImage renderImage:@"Done"] forState:UIControlStateNormal];

    
    //Capture
    self.captureBut.tintColor=[UIColor whiteColor];
    self.captureBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.captureBut.layer.cornerRadius = self.captureBut.frame.size.width / 2;
    self.captureBut.clipsToBounds=YES;
    
    [self.captureBut setImage:[UIImage renderImage:@"CameraCapture"] forState:UIControlStateNormal];
    
    //Retake
    self.retakeBut.tintColor=[UIColor whiteColor];
    self.retakeBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.retakeBut.layer.cornerRadius = self.retakeBut.frame.size.width / 2;
    self.retakeBut.clipsToBounds=YES;
    
    [self.retakeBut setImage:[UIImage renderImage:@"Retake"] forState:UIControlStateNormal];
    
    //Back
    self.backBut.tintColor=[UIColor whiteColor];
    self.backBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.backBut.layer.cornerRadius = self.backBut.frame.size.width / 2;
    self.backBut.clipsToBounds=YES;
    
    [self.backBut setImage:[UIImage renderImage:@"Back"] forState:UIControlStateNormal];
    
    
}

-(void)setUpCameraFoundation{
   
    if (_imageStreamV == nil) _imageStreamV = [[UIView alloc]init];
    _imageStreamV.alpha = 1;
    _imageStreamV.frame = self.view.bounds;
//    _imageStreamV.frame=CGRectMake(0, 64, self.view.bounds.size.width, 350);
    [self.view addSubview:_imageStreamV];
    
    // SETTING UP CAM
    if (_mySesh == nil) _mySesh = [[AVCaptureSession alloc] init];
    
    //muku
    _mySesh.sessionPreset = AVCaptureSessionPresetPhoto;
    
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_mySesh];
    _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _captureVideoPreviewLayer.frame = _imageStreamV.layer.bounds; // parent of layer
    
    [_imageStreamV.layer addSublayer:_captureVideoPreviewLayer];
    
    // rear camera: 0 front camera: 1
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    if (devices.count==0) {
        NSLog(@"SC: No devices found (for example: simulator)");
        return;
    }
    _myDevice = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0];
    
    if ([_myDevice isFlashAvailable] && _myDevice.flashActive && [_myDevice lockForConfiguration:nil]) {
        //NSLog(@"SC: Turning Flash Off ...");
        _myDevice.flashMode = AVCaptureFlashModeOff;
        [_myDevice unlockForConfiguration];
    }
    
    NSError * error = nil;
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_myDevice error:&error];
    
//    if (!input) {
//        // Handle the error appropriately.
//        NSLog(@"SC: ERROR: trying to open camera: %@", error);
//        [_delegate simpleCam:self didFinishWithImage:_capturedImageV.image];
//    }
    
    [_mySesh addInput:input];
    
    _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [_stillImageOutput setOutputSettings:outputSettings];
    [_mySesh addOutput:_stillImageOutput];
    
    
    [_mySesh startRunning];
    
   _captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    
    //Captured Image Output
    if (_capturedImageV == nil) _capturedImageV = [[UIImageView alloc]init];
    _capturedImageV.frame = _imageStreamV.frame; // just to even it out
    _capturedImageV.backgroundColor = [UIColor clearColor];
    _capturedImageV.userInteractionEnabled = YES;
    _capturedImageV.clipsToBounds=YES;
    _capturedImageV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:_capturedImageV aboveSubview:_imageStreamV];
    
    UIPinchGestureRecognizer * pinchZoom = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchZoom.delegate=self;
    [_capturedImageV addGestureRecognizer:pinchZoom];

    
}

#pragma mark TAP TO FOCUS

- (void) tapSent:(CGPoint)sender {
    
    if (_capturedImageV.image == nil) {
        CGPoint aPoint = sender;//[sender locationInView:_imageStreamV];
        if (_myDevice != nil) {
            if([_myDevice isFocusPointOfInterestSupported] &&
               [_myDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                
                // we subtract the point from the width to inverse the focal point
                // focus points of interest represents a CGPoint where
                // {0,0} corresponds to the top left of the picture area, and
                // {1,1} corresponds to the bottom right in landscape mode with the home button on the right—
                // THIS APPLIES EVEN IF THE DEVICE IS IN PORTRAIT MODE
                // (from docs)
                // this is all a touch wonky
                double pX = aPoint.x / _imageStreamV.bounds.size.width;
                double pY = aPoint.y / _imageStreamV.bounds.size.height;
                double focusX = pY;
                // x is equal to y but y is equal to inverse x ?
                double focusY = 1 - pX;
                
                //NSLog(@"SC: about to focus at x: %f, y: %f", focusX, focusY);
                if([_myDevice isFocusPointOfInterestSupported] && [_myDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                    
                    if([_myDevice lockForConfiguration:nil]) {
                        [_myDevice setFocusPointOfInterest:CGPointMake(focusX, focusY)];
                        [_myDevice setFocusMode:AVCaptureFocusModeAutoFocus];
                        [_myDevice setExposurePointOfInterest:CGPointMake(focusX, focusY)];
                        [_myDevice setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
                        
                        
                        //NSLog(@"SC: Done Focusing");
                    }
                    [_myDevice unlockForConfiguration];
                }
            }
        }
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    [self tapSent:touchPoint];
    
   
    
    if (_camFocus)
    {
        [_camFocus removeFromSuperview];
    }
    if (YES)
    {
        _camFocus = [[CameraFocusSquare alloc]initWithFrame:CGRectMake(touchPoint.x-40, touchPoint.y-40, 80, 80)];
        [_camFocus setBackgroundColor:[UIColor clearColor]];
        [_imageStreamV addSubview:_camFocus];
        [_camFocus setNeedsDisplay];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:3.0];
        [_camFocus setAlpha:0.0];
        [UIView commitAnimations];
    }
    
}
#pragma mark CLOSE

- (void) closeWithCompletion:(void (^)(void))completion {
    
    // Need alpha 0.0 before dismissing otherwise sticks out on dismissal
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        completion();
        
        [_mySesh stopRunning];
        _mySesh = nil;
        
        _capturedImageV.image = nil;
        [_capturedImageV removeFromSuperview];
        _capturedImageV = nil;
        
        [_imageStreamV removeFromSuperview];
        _imageStreamV = nil;
        
        
        _stillImageOutput = nil;
        _myDevice = nil;
        
        self.view = nil;
        _camdelegate = nil;
        [self removeFromParentViewController];
        
    }];
}

- (void) capturePhoto {
    if (isCapturingImage) {
        return;
    }
    isCapturingImage = YES;
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _stillImageOutput.connections)
    {
        for (AVCaptureInputPort *port in [connection inputPorts])
        {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] )
            {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    
    /*For Zoom Functionality*/
    if(videoConnection!=nil){
       [videoConnection setVideoScaleAndCropFactor:effectiveScale];
    }
   
    
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         if(!CMSampleBufferIsValid(imageSampleBuffer))
         {
             return;
         }
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         UIImage * capturedImage = [[UIImage alloc]initWithData:imageData scale:1];
         NSLog(@"%lu",(unsigned long)UIImageJPEGRepresentation(capturedImage, 1.0).length);
         if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][0]) {
             // rear camera active
//             CGImageRef cgRef = capturedImage.CGImage;
             capturedImage = capturedImage;
         }
         else if (_myDevice == [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo][1]) {
             // front camera active
             
//             // flip to look the same as the camera
//             if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationLeftMirrored];
//             else {
//                 if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)
//                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationDownMirrored];
//                 else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
//                     capturedImage = [UIImage imageWithCGImage:capturedImage.CGImage scale:capturedImage.scale orientation:UIImageOrientationUpMirrored];
//             }
             
         }
         
         isCapturingImage = NO;
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             _capturedImageV.image = capturedImage;
             
         }];
         
         imageData = nil;
         
        
         
//         // If we have disabled the photo preview directly fire the delegate callback, otherwise, show user a preview//take photo immediatelty
//         _disablePhotoPreview ? [self photoCaptured] : [self drawControls];
     }];
}


- (IBAction)capturePhoto:(id)sender {
    
    
    [self capturePhoto];
    [_mySesh stopRunning];
    [UIView animateWithDuration:0.3 animations:^{
        self.switchCameraBut.alpha=0;
        self.flashBut.alpha=0;
        self.retakeBut.alpha=1;
        self.doneBut.alpha=1;
        
    }];
}

- (IBAction)retakeAction:(id)sender {
    
    
   
    [_mySesh startRunning];
     _capturedImageV.image=nil;
    [UIView animateWithDuration:0.3 animations:^{
        self.switchCameraBut.alpha=1;
        self.flashBut.alpha=1;
        self.retakeBut.alpha=0;
        self.doneBut.alpha=0;
        
    }];

}

- (IBAction)doneAction:(id)sender {
//    if(_capturedImageV.image!=nil){
//        CropViewController *crop=[self.storyboard instantiateViewControllerWithIdentifier:@"crop"];
//        crop.adjustedImage=_capturedImageV.image;
//        [self presentViewController:crop animated:YES completion:nil];
//    }
   
//    [self saveImage:_capturedImageV.image];
    [self.camdelegate didFinishCaptureImage:_capturedImageV.image withMMCam:self];
    
}

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    
    effectiveScale = beginGestureScale * recognizer.scale;
    
    if (effectiveScale < 1.0){
        
         effectiveScale = 1.0;

    }
        
    
    
//    CGFloat maxScaleAndCropFactor = [[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
    
   else if (effectiveScale > 5){
         effectiveScale = 5;
       
    }
    
   else{
       
   }
       
    
    
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:.025];
    
    [_captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(effectiveScale, effectiveScale)];
    
    [CATransaction commit];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.zoomSlider.value = effectiveScale/5;
        
    }];
    NSLog(@"%f %f",recognizer.scale,[[_stillImageOutput connectionWithMediaType:AVMediaTypeVideo] videoScaleAndCropFactor]);
    
    
    
}
- (IBAction)zoomsliderAction:(UISlider *)sender {
    
    [self slideZoomINOUT:sender.value];
   
}

- (IBAction)flashAction:(id)sender {
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([_myDevice hasTorch] && [_myDevice position]==AVCaptureDevicePositionBack) {
        [_myDevice lockForConfiguration:nil];
        
        if(toogleFlash){
            [_myDevice setTorchMode:AVCaptureTorchModeOff];
        }
        else{
            [_myDevice setTorchMode:AVCaptureTorchModeOn];
        }
        
        [_myDevice unlockForConfiguration];
    }
    
    toogleFlash=!toogleFlash;
}

- (IBAction)switchCameraAction:(id)sender {
    AVCaptureDevicePosition desiredPosition;
    if (toggleCamera){
        [self.flashBut setEnabled:YES];
        desiredPosition = AVCaptureDevicePositionBack;
    }
    
    else{
        
        [self.flashBut setEnabled:NO];
        toogleFlash=NO;
        [_myDevice lockForConfiguration:nil];
        [_myDevice setTorchMode:AVCaptureTorchModeOff];
        [_myDevice unlockForConfiguration];
        desiredPosition = AVCaptureDevicePositionFront;
    }
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [[_captureVideoPreviewLayer session] beginConfiguration];
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[_captureVideoPreviewLayer session] inputs]) {
                [[_captureVideoPreviewLayer session] removeInput:oldInput];
            }
            [[_captureVideoPreviewLayer session] addInput:input];
            [[_captureVideoPreviewLayer session] commitConfiguration];
            break;
        }
    }
    toggleCamera = !toggleCamera;
}

- (IBAction)backToParent:(id)sender {
    
    [self.camdelegate didFinishCaptureImage:nil withMMCam:self];
   
}

-(void)slideZoomINOUT:(CGFloat)scale{
    effectiveScale = scale*5;
    
    if (effectiveScale < 1.0)
        
        effectiveScale = 1.0;
    
    if (effectiveScale > 5)
        
        effectiveScale = 5;
    
    [CATransaction begin];
    
    [CATransaction setAnimationDuration:.025];
    
    [_captureVideoPreviewLayer setAffineTransform:CGAffineTransformMakeScale(effectiveScale, effectiveScale)];
    
    [CATransaction commit];
    
}

#pragma mark Latest Photo
- (void)latestPhotoWithCompletion:(void (^)(UIImage *photo))completion
{
    
    ALAssetsLibrary *library=[[ALAssetsLibrary alloc] init];
    // Enumerate just the photos and videos group by using ALAssetsGroupSavedPhotos.
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        
        // Within the group enumeration block, filter to enumerate just photos.
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        
        // For this example, we're only interested in the last item [group numberOfAssets]-1 = last.
        if ([group numberOfAssets] > 0) {
            [group enumerateAssetsAtIndexes:[NSIndexSet indexSetWithIndex:[group numberOfAssets]-1] options:0
                                 usingBlock:^(ALAsset *alAsset, NSUInteger index, BOOL *innerStop) {
                                     // The end of the enumeration is signaled by asset == nil.
                                     if (alAsset) {
                                         ALAssetRepresentation *representation = [alAsset defaultRepresentation];
                                         // Do something interesting with the AV asset.
                                         UIImage *img = [UIImage imageWithCGImage:[representation fullScreenImage]];
                                         
                                         // completion
                                         completion(img);
                                         
                                         // we only need the first (most recent) photo -- stop the enumeration
                                         *innerStop = YES;
                                     }
                                 }];
        }
    } failureBlock: ^(NSError *error) {
        // Typically you should handle an error more gracefully than this.
    }];
    

}

- (NSString *)directory
{
    NSMutableString *path = [NSMutableString new];
    [path appendString:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    [path appendString:@"/Images/"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        
        if (error) {
            return nil;
        }
    }
    
    return path;
}

- (NSURL *)saveJPGImageAtDocumentDirectory:(UIImage *)image {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:SSSSZ"];
    
    NSString *directory = [self directory];
    
    if (!directory) {
        
        return nil;
    }
    
    NSString *fileName = [[dateFormatter stringFromDate:[NSDate date]] stringByAppendingPathExtension:@"jpg"];
    NSString *filePath = [directory stringByAppendingString:fileName];
    
    if (filePath == nil) {
        
        return nil;
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1);
    [data writeToFile:filePath atomically:YES];
    
    NSURL *assetURL = [NSURL URLWithString:filePath];
    
    NSLog(@"%@",assetURL);
    return assetURL;
}

#pragma maek new doc
- (void)saveImage: (UIImage*)image
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:
                          @"test.png" ];
        NSData* data = UIImagePNGRepresentation(image);
        [data writeToFile:path atomically:YES];
    }
}

- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      @"test.png" ];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

@end
