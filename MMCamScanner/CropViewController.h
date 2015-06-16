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

@class CropViewController;
@protocol MMCropDelegate <NSObject>

-(void)didFinishCropping:(UIImage *)finalCropImage from:(CropViewController *)cropObj;

@end
@interface CropViewController : UIViewController
@property (weak,nonatomic) id<MMCropDelegate> cropdelegate;
@property (strong, nonatomic) UIImageView *sourceImageView;
@property (strong, nonatomic) UIImage *sourceImage;
@property (weak, nonatomic) IBOutlet UIButton *dismissBut;
@property (weak, nonatomic) IBOutlet UIButton *cropBut;
@property (strong, nonatomic) UIImage *adjustedImage;
- (IBAction)cropAction:(id)sender;
- (IBAction)dismissAction:(id)sender;

//Detect Edges
-(void)detectEdges;
- (void) closeWithCompletion:(void (^)(void))completion ;
@end
