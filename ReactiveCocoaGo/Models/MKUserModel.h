//
//  MKUserModel.h
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKUserModel : NSObject
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *gender;

+ (instancetype)useModelWithUsername:(NSString *)username gender:(NSString *)gender;
@end
