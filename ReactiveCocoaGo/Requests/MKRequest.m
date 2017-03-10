//
//  MKRequest.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/10.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKRequest.h"

@implementation MKRequest

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void (^)(void))success failure:(void (^)(void))failure {
    NSLog(@"\n%s\nusername=%@\npassword=%@", __func__, username, password);
    
    //模拟登录请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([username isEqualToString:@"monki"] && [password isEqualToString:@"123"]) {
                if (success) {
                    success();
                }
            } else {
                if (failure) {
                    failure();
                }
            }
        });
    });
}
@end
