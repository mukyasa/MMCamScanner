//
//  CropViewController.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UIImage+fixOrientation.h"
#import "UIImageView+ContentFrame.h"

#import "ProgressHUD.h"
@class CropViewController;
@protocol MMCropDelegate <NSObject>

-(void)didFinishCropping:(UIImage *)finalCropImage from:(CropViewController *)cropObj;

@end
@interface CropViewController : UIViewController{
    CGFloat _rotateSlider;
    CGRect _initialRect,final_Rect;
}
@property (weak,nonatomic) id<MMCropDelegate> cropdelegate;
@property (strong, nonatomic) UIImageView *sourceImageView;
@property (weak, nonatomic) IBOutlet UIButton *dismissBut;
@property (weak, nonatomic) IBOutlet UIButton *cropBut;
@property (weak, nonatomic) IBOutlet UIButton *rightRotateBut;
@property (weak, nonatomic) IBOutlet UIButton *leftRotateBut;


@property (strong, nonatomic) UIImage *adjustedImage,*cropgrayImage,*cropImage;
- (IBAction)cropAction:(id)sender;
- (IBAction)dismissAction:(id)sender;
- (IBAction)rightRotateAction:(id)sender;
- (IBAction)leftRotateAction:(id)sender;

//Detect Edges
-(void)detectEdges;
- (void) closeWithCompletion:(void (^)(void))completion ;
@end
