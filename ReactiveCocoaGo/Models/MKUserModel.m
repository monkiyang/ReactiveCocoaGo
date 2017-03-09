//
//  MKUserModel.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKUserModel.h"

@interface MKUserModel()
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *gender;
@end

@implementation MKUserModel

+ (instancetype)useModelWithUsername:(NSString *)username gender:(NSString *)gender {
    MKUserModel *userModel = [[MKUserModel alloc] init];
    userModel.username = username;
    userModel.gender = gender;
    return userModel;
}
@end
