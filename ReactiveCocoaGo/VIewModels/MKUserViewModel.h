//
//  MKUserViewModel.h
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveObjC/ReactiveObjC.h>

#import "MKUserModel.h"

@interface MKUserViewModel : NSObject
@property (nonatomic, strong, readonly) MKUserModel *userModel;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@end
