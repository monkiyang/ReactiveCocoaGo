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

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation ViewController

- (void)loadView {
    [super loadView];
    
    [self setupSubviews];
}

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
    //skip: 跳过skipCount次链式调用
    [[[RACObserve(self, username) skip:1] filter:^(NSString *username) {
        return [username isEqualToString:@"Mengqi Yang"];
    }] subscribeNext:^(NSString *username) {
        NSLog(@"\n%s\nusername:%@", __func__, username);
    }];
    [self addObserver:self forKeyPath:@"username" options:NSKeyValueObservingOptionNew context:nil];
    self.username = @"ReactiveObjC";
    //对比RAC与KVO，链式调用代码更集中连贯
    
    //当密码与确认密码相等时self.createEnabled为true
    //RAC()绑定target与keypath，nilvalue意义不明
    //combineLatest: 联合信号对象
    //reduce: block返回值即为属性值
    RAC(self, createEnabled) = [RACSignal combineLatest:@[RACObserve(self, password), RACObserve(self, passwordConfirmation)] reduce:^(NSString *password, NSString *passwordConfirmation) {
        return @([password isEqualToString:passwordConfirmation]);
    }];
    self.password = @"123";
    NSLog(@"\n%s\n_createEnabled:%@", __func__, _createEnabled?@"YES":@"NO");
    self.passwordConfirmation = @"123";
    NSLog(@"\n%s\n_createEnabled:%@", __func__, _createEnabled?@"YES":@"NO");
    
    //点击登录按钮处理登录请求
    //RACCommand绑定UI响应事件
    @weakify(self);
    RACCommand *loginCommand = [[RACCommand alloc] initWithSignalBlock:^(UIButton *sender) {
        NSLog(@"\n%s\nlogin button clicked", __func__);
        @strongify(self);
        self.statusLabel.text = @"登录中...";
        return [self login];
    }];
    [loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        
        [loginSignal subscribeNext:^(NSString *messge) {
            NSLog(@"\n%s\n%@", __func__, messge);
            @strongify(self);
            self.statusLabel.text = @"登录成功";
        }];
    }];
    //.errors错误信号订阅nextBlock
    [loginCommand.errors subscribeNext:^(NSError *error) {
        NSLog(@"\n%s\n%@", __func__, error);
        self.statusLabel.text = @"登录失败";
    }];
    self.loginButton.rac_command = loginCommand;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}

#pragma mark - Private Methods
- (void)setupSubviews {
    [self.view addSubview:self.loginButton];
    
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"loginButton": _loginButton};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton(44.)]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20.-[loginButton(44.)]" options:0 metrics:nil views:views]];
    
    [self.view addSubview:self.statusLabel];
    
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    views = @{@"loginButton": _loginButton , @"statusLabel": _statusLabel};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginButton][statusLabel]" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}

- (RACSignal *)login {
    
    RACSignal *loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        //模拟登录请求
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1. * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //登录失败
//                [subscriber sendError:[NSError errorWithDomain:@"com.monkiyang.login.error" code:1000 userInfo:@{NSLocalizedDescriptionKey: @"login failed"}]];
                //登录成功
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

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *username = change[NSKeyValueChangeNewKey];
    NSLog(@"\n%s\nusername:%@", __func__, username);
}

#pragma mark - Setter && Getter Methods
- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.exclusiveTouch = YES;
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:14.];
        _loginButton.backgroundColor = [UIColor greenColor];
        
        [_loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.font = [UIFont systemFontOfSize:14.];
        _statusLabel.textColor = [UIColor blackColor];
    }
    return _statusLabel;
}
@end
