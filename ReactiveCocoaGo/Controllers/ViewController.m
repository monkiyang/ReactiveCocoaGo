//
//  ViewController.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/6.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "ViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "LoginView.h"

#import "LoginViewModel.h"

@interface ViewController ()
@property (nonatomic, copy) NSString *username;///<用户昵称

@property (nonatomic, copy) NSString *password;///<密码
@property (nonatomic, copy) NSString *passwordConfirmation;
@property (nonatomic, assign) BOOL createEnabled;

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) LoginViewModel *loginViewModel;
@end

@implementation ViewController

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"ReactiveCocoaGo";
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self learnRACObserve];
    [self learnRAC];
    [self learnRACCommand];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)updateViewConstraints {
    
    [super updateViewConstraints];
}

#pragma mark - Private Methods
- (void)setupSubviews {
    [self.view addSubview:self.loginView];
    
    _loginView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"loginView": _loginView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginView]" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loginView]" options:0 metrics:nil views:views]];
}

- (void)learnRACObserve {
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
}

- (void)learnRAC {
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
}

- (void)learnRACCommand {
    //点击登录按钮处理登录请求
    //RACCommand绑定UI响应事件
    self.loginView.loginButton.rac_command = self.loginViewModel.loginCommand;
    @weakify(self);
    [_loginViewModel.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        @strongify(self);
        self.loginView.statusLabel.text = @"登录中...";

        [loginSignal subscribeNext:^(NSString *messge) {
            NSLog(@"\n%s\n%@", __func__, messge);
            @strongify(self);
            self.loginView.statusLabel.text = @"登录成功";
        }];
    }];
    //.errors错误信号订阅nextBlock
    [_loginViewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        NSLog(@"\n%s\n%@", __func__, error);
        @strongify(self);
        self.loginView.statusLabel.text = @"登录失败";
    }];
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *username = change[NSKeyValueChangeNewKey];
    NSLog(@"\n%s\nusername:%@", __func__, username);
}

#pragma mark - Setter && Getter Methods
- (LoginView *)loginView {
    if (!_loginView) {
        _loginView = [[LoginView alloc] init];
    }
    return _loginView;
}

- (LoginViewModel *)loginViewModel {
    if (!_loginViewModel) {
        _loginViewModel = [[LoginViewModel alloc] init];
    }
    return _loginViewModel;
}
@end
