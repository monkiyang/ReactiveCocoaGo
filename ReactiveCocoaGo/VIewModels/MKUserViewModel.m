//
//  MKUserViewModel.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKUserViewModel.h"

@interface MKUserViewModel ()
@property (nonatomic, strong) RACCommand *loginCommand;

@property (nonatomic, strong) MKUserModel *userModel;
@end

@implementation MKUserViewModel

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Private Methods
- (RACSignal *)login {
    
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //模拟登录请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //登录失败
//                [subscriber sendError:[NSError errorWithDomain:@"com.monkiyang.login.error" code:1000 userInfo:@{NSLocalizedDescriptionKey: @"login failed"}]];
                
                //登录成功
                //解析用户数据
                self.userModel = [MKUserModel useModelWithUsername:@"Monki Yang" gender:@"Man"];
                [subscriber sendNext:@"login successfully"];
                [subscriber sendCompleted];
            });
        });
        
        return [RACDisposable disposableWithBlock:^{
            //信号丢弃后block处理
            NSLog(@"\n%s_disposableWithBlock", __func__);
        }];
    }];
    
    return loginSignal;
}

#pragma mark - Setter && Getter Methods
- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        //点击登录按钮处理登录请求
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^(UIButton *sender) {
            NSLog(@"\n%s\nlogin button clicked", __func__);
            @strongify(self);
            return [self login];
        }];
    }
    return _loginCommand;
}
@end
