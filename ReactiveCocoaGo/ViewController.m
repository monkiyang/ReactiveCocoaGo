//
//  ViewController.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/6.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

@interface ViewController ()
@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *passwordConfirmation;
@property (nonatomic, assign) BOOL createEnabled;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //当self.username改变时打印用户名称
    [[self rac_valuesForKeyPath:@"username" observer:self] subscribeNext:^(NSString *username) {
        NSLog(@"\n%s\nusername:%@", __func__, username);
    }];
    [[self rac_valuesAndChangesForKeyPath:@"username" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
        NSString *username = tuple.first;
        NSLog(@"\n%s\nusername:%@", __func__, username);
    }];
    //以等于“Mengqi Yang”规则来过滤
    [[RACObserve(self, username) filter:^(NSString *username) {
        return [username isEqualToString:@"Mengqi Yang"];
    }] subscribeNext:^(NSString *username) {
        NSLog(@"\n%s\nusername:%@", __func__, username);
    }];
  
    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew context:nil];
    self.username = @"ReactiveObjc";
    //对比RAC与KVO，链式调用代码更集中连贯
    
    //当密码与确认密码相等时self.createEnabled为true
    //RAC()绑定target与keypath，nilvalue意义不明
    //combineLatest:联合信号对象
    //reduce:block返回值即为属性值
    RAC(self, createEnabled) = [RACSignal combineLatest:@[RACObserve(self, password), RACObserve(self, passwordConfirmation)] reduce:^(NSString *password, NSString *passwordConfirmation) {
        return @([password isEqualToString:passwordConfirmation]);
    }];
    self.password = @"123";
    NSLog(@"\n%s\n_createEnabled:%@", __func__, _createEnabled?@"YES":@"NO");
    self.passwordConfirmation = @"123";
    NSLog(@"\n%s\n_createEnabled:%@", __func__, _createEnabled?@"YES":@"NO");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *username = change[NSKeyValueChangeNewKey];
    NSLog(@"\n%s\nusername:%@", __func__, username);
}
@end
