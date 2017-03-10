//
//  MKUserViewModel.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKUserViewModel.h"

@interface MKUserViewModel ()
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) MKUserModel *userModel;

@property (nonatomic, strong) RACCommand *loginCommand;
@end

@implementation MKUserViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.status = @"";
        self.userModel = [[MKUserModel alloc] init];
        _userModel.nickname = @"";
        _userModel.gender = @"";
        
        [self bindModel];
    }
    return self;
}

#pragma mark - Private Methods
- (RACSignal *)login {
    
    @weakify(self);
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //模拟登录请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self);
                //登录失败
//                [subscriber sendError:[NSError errorWithDomain:@"com.monkiyang.login.error" code:1000 userInfo:@{NSLocalizedDescriptionKey: @"login failed"}]];
                
                //登录成功
                //解析用户数据
                self.userModel.nickname = @"Monki Yang";
                self.userModel.gender = @"male";
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

- (void)bindModel {
    RAC(self, nickname) = [RACObserve(_userModel, nickname) map:^id(NSString *value) {
        if (value.length == 0) {
            return value;
        }
        return [NSString stringWithFormat:@"My nickname is %@, ", value];
    }];
    RAC(self, gender) = [RACObserve(_userModel, gender) map:^id(NSString *value) {
        if (value.length == 0) {
            return value;
        }
        return [NSString stringWithFormat:@"I'm %@.", value];
    }];
}

#pragma mark - Setter && Getter Methods
- (RACCommand *)loginCommand {
    if (!_loginCommand) {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^(UIButton *sender) {
            NSLog(@"\n%s\nlogin button clicked", __func__);
            @strongify(self);
            return [self login];
        }];
        [_loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
            @strongify(self);
            self.status = @"登录中...";
            self.userModel.nickname = @"";
            self.userModel.gender = @"";
            
            [loginSignal subscribeNext:^(NSString *messge) {
                NSLog(@"\n%s\n%@", __func__, messge);
                @strongify(self);
                self.status = @"登录成功";
            }];
        }];
        //.errors错误信号订阅nextBlock
        [_loginCommand.errors subscribeNext:^(NSError *error) {
            NSLog(@"\n%s\n%@", __func__, error);
            @strongify(self);
            self.status = @"登录失败";
            self.userModel.nickname = @"";
            self.userModel.gender = @"";
        }];
    }
    return _loginCommand;
}
@end
