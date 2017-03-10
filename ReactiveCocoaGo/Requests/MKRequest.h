//
//  MKRequest.h
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/10.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKRequest : NSObject

+ (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(void(^)(void))success failure:(void(^)(void))failure;
@end
