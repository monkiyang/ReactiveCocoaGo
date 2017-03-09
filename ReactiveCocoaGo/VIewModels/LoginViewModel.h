//
//  LoginViewModel.h
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveObjC/ReactiveObjC.h>

@interface LoginViewModel : NSObject
@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@end
