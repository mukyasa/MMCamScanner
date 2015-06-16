//
//  ViewController.h
//  MMCamScanner
//
//  Created by mukesh mandora on 09/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RippleAnimation.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *cameraBut;

- (IBAction)cameraAction:(id)sender;

@end

