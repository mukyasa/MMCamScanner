//
//  UploadManager.m
//  MMCamScanner
//
//  Created by mukesh mandora on 29/06/15.
//  Copyright (c) 2015 madapps. All rights reserved.
//

#import "UploadManager.h"
#import "AppDelegate.h"

@interface UploadManager ()
@property (strong,nonatomic) NSURLSession *uploadSession;
@end
@implementation UploadManager
+(instancetype)shared{
    static dispatch_once_t onceToken;
    static UploadManager *uploader=nil;
    
    dispatch_once(&onceToken, ^{
        
        uploader=[UploadManager new];
    });
    
    return uploader;
    
}

-(id)init{
    self=[super init];
    if(self){
        
        NSURLSessionConfiguration *uploadConfig=[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"UploadDemo"];
//        uploadConfig.timeoutIntervalForRequest = 30;
//        uploadConfig.timeoutIntervalForResource = 30;
//        uploadConfig.HTTPMaximumConnectionsPerHost = 1;
//        uploadConfig.sessionSendsLaunchEvents=YES;
        uploadConfig.allowsCellularAccess = YES;
        uploadConfig.networkServiceType = NSURLNetworkServiceTypeBackground;
//        uploadConfig.discretionary = YES;
        self.uploadSession=[NSURLSession sessionWithConfiguration:uploadConfig delegate:self delegateQueue:nil];

    }
    
    return self;
}

-(NSURLSessionUploadTask *) uploadTaskWithURL:(NSMutableURLRequest*)urlrequest withImageData:(NSString *)imgData{
    
    NSLog(@"File Path%@",[NSURL fileURLWithPath:imgData]);
    
    return [self.uploadSession uploadTaskWithRequest:urlrequest fromFile:[NSURL fileURLWithPath:imgData]];
    
}

#pragma mark urldelegate method
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
    CGFloat progress=(CGFloat)totalBytesSent/totalBytesExpectedToSend;
    
    NSDictionary *userInfo=@{@"progress":@(progress)};
    
//    NSLog(@"Progress %f",progress);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadProgress" object:task userInfo:userInfo];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    if (error != nil) {
        // Something went wrong...
        NSLog(@"Background transfer is failed %@",error.description);
        return;
    }
    
    // Also check http status code
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    if ([response statusCode] >= 300) {
        NSLog(@"Background transfer is failed, status code: %ld", (long)[response statusCode]);
        return;
    }
    NSLog(@"Background transfer is success");

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadCompletion" object:task userInfo:nil];
    
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data {
    
    NSString *resp = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];

    NSLog(@"Echo %@",resp);
}

-(void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session{
    AppDelegate *appdelegate=[[UIApplication sharedApplication] delegate];
    
    if(appdelegate.backgroundSessionCompletionHandler){
        appdelegate.backgroundSessionCompletionHandler();
        appdelegate.backgroundSessionCompletionHandler=nil;
    }
}
@end
