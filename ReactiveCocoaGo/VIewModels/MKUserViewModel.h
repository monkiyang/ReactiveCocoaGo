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
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, copy, readonly) NSString *gender;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@end
