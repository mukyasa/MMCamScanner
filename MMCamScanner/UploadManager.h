//
//  UploadManager.h
//  MMCamScanner
//
//  Created by mukesh mandora on 29/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface UploadManager : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate>
+(instancetype)shared;
-(NSURLSessionUploadTask *) uploadTaskWithURL:(NSMutableURLRequest*)url withImageData:(NSString *)imgData;
@end
