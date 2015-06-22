//
//  ViewController.m
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import "ViewController.h"
#import "MMCameraPickerController.h"
#import "CropViewController.h"
#define backgroundHex @"2196f3"
#import "UIColor+HexRepresentation.h"
#import "UIImage+fixOrientation.h"
//#import <TesseractOCR/TesseractOCR.h>

@interface ViewController ()<MMCameraDelegate,MMCropDelegate/*G8TesseractDelegate*/>
{
    RippleAnimation *ripple;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setUI];
      self.view.backgroundColor=[UIColor colorWithHexString:@"f44336"];
   
}





-(void)setUI{
    self.cameraBut.tintColor=[UIColor whiteColor];
    self.cameraBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.cameraBut.layer.cornerRadius = self.cameraBut.frame.size.width / 2;
    self.cameraBut.clipsToBounds=YES;
    [self.cameraBut setImage:[UIImage renderImage:@"Camera"] forState:UIControlStateNormal];

    
    self.pickerBut.tintColor=[UIColor whiteColor];
    self.pickerBut.backgroundColor=[UIColor colorWithHexString:backgroundHex];
    self.pickerBut.layer.cornerRadius = self.pickerBut.frame.size.width / 2;
    self.pickerBut.clipsToBounds=YES;
    [self.pickerBut setImage:[UIImage renderImage:@"Gallery"] forState:UIControlStateNormal];
}

/*OCR Method Implementation*/
//-(void)OCR:(UIImage *)image{
//    // Create RecognitionOperation
//    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc] init];
//    
//    // Configure inner G8Tesseract object as described before
//    operation.tesseract.language = @"eng";
////    operation.tesseract.charWhitelist = @"01234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
//    operation.tesseract.image = [image g8_blackAndWhite];
//    operation.tesseract.delegate=self;
//    // Setup the recognitionCompleteBlock to receive the Tesseract object
//    // after text recognition. It will hold the recognized text.
//    operation.recognitionCompleteBlock = ^(G8Tesseract *recognizedTesseract) {
//        // Retrieve the recognized text upon completion
//        NSLog(@" OCR TEXT%@", [recognizedTesseract recognizedText]);
//    };
//    
//    // Add operation to queue
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [queue addOperation:operation];
//
//}


/*OCR Delegate*/
//#pragma mark OCR delegate
//- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
////    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
//}
//
//- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
//    return NO;  // return YES, if you need to interrupt tesseract before it finishes
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


- (IBAction)cameraAction:(id)sender {
    MMCameraPickerController *cameraPicker=[self.storyboard instantiateViewControllerWithIdentifier:@"camera"];
    ripple=[[RippleAnimation alloc] init];
    cameraPicker.camdelegate=self;
    cameraPicker.transitioningDelegate=ripple;
    ripple.touchPoint=self.cameraBut.frame;
   
    [self presentViewController:cameraPicker animated:YES completion:nil];
    
    

}

- (IBAction)pickerAction:(id)sender {
    _invokeCamera = [[UIImagePickerController alloc] init];
    _invokeCamera.delegate = self;
    ripple=[[RippleAnimation alloc] init];
    ripple.touchPoint=self.pickerBut.frame;
    _invokeCamera.transitioningDelegate=ripple;
    _invokeCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _invokeCamera.allowsEditing = NO;
     [self presentViewController:_invokeCamera animated:YES completion:nil];

}

#pragma mark Picker delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_invokeCamera dismissViewControllerAnimated:YES completion:nil];
    [_invokeCamera removeFromParentViewController];
    ripple=nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     [_invokeCamera dismissViewControllerAnimated:YES completion:nil];
    [_invokeCamera removeFromParentViewController];
    ripple=nil;
    
    
    CropViewController *crop=[self.storyboard instantiateViewControllerWithIdentifier:@"crop"];
    crop.cropdelegate=self;
    ripple=[[RippleAnimation alloc] init];
    crop.transitioningDelegate=ripple;
    ripple.touchPoint=self.cameraBut.frame;
    crop.adjustedImage=[[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
    
    [self presentViewController:crop animated:YES completion:nil];
    
    
}

#pragma mark Camera Delegate
-(void)didFinishCaptureImage:(UIImage *)capturedImage withMMCam:(MMCameraPickerController*)cropcam{
    
    [cropcam closeWithCompletion:^{
        NSLog(@"dismissed");
        ripple=nil;
        if(capturedImage!=nil){
            CropViewController *crop=[self.storyboard instantiateViewControllerWithIdentifier:@"crop"];
            crop.cropdelegate=self;
            ripple=[[RippleAnimation alloc] init];
            crop.transitioningDelegate=ripple;
            ripple.touchPoint=self.cameraBut.frame;
            crop.adjustedImage=capturedImage;
            
            [self presentViewController:crop animated:YES completion:nil];
        }
    }];
    
    
}
-(void)authorizationStatus:(BOOL)status{
    
}

#pragma mark crop delegate
-(void)didFinishCropping:(UIImage *)finalCropImage from:(CropViewController *)cropObj{
    [cropObj closeWithCompletion:^{
        ripple=nil;
    }];
    
    /*OCR Call*/
//     [self OCR:finalCropImage];
}
@end
