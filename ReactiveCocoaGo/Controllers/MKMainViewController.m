//
//  MKMainViewController.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/6.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKMainViewController.h"

#import <ReactiveObjC/ReactiveObjC.h>

#import "MKLoginView.h"
#import "MKInfoView.h"

#import "MKUserViewModel.h"

@interface MKMainViewController ()
@property (nonatomic, copy) NSString *account;///<账号

@property (nonatomic, copy) NSString *password;///<密码
@property (nonatomic, copy) NSString *passwordConfirmation;
@property (nonatomic, assign) BOOL createEnabled;

@property (nonatomic, strong) MKLoginView *loginView;
@property (nonatomic, strong) MKInfoView *infoView;

@property (nonatomic, strong) MKUserViewModel *userViewModel;
@end

@implementation MKMainViewController

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
    
    [self.view addSubview:self.infoView];
    
    _infoView.translatesAutoresizingMaskIntoConstraints = NO;
    views = @{@"loginView": _loginView, @"infoView": _infoView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[loginView][infoView]" options:NSLayoutFormatAlignAllLeft metrics:nil views:views]];
}

- (void)learnRACObserve {
    //当self.account改变时打印用户名称
    [[self rac_valuesForKeyPath:@"account" observer:self] subscribeNext:^(NSString *account) {
        NSLog(@"\n%s\naccount:%@", __func__, account);
    }];
    [[self rac_valuesAndChangesForKeyPath:@"account" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTuple *tuple) {
        NSString *account = tuple.first;
        NSLog(@"\n%s\naccount:%@", __func__, account);
    }];
    //以等于“Mengqi Yang”规则来过滤
    //skip: 跳过skipCount次链式调用
    [[[RACObserve(self, account) skip:1] filter:^(NSString *account) {
        return [account isEqualToString:@"Mengqi Yang"];
    }] subscribeNext:^(NSString *account) {
        NSLog(@"\n%s\naccount:%@", __func__, account);
    }];
    [self addObserver:self forKeyPath:@"account" options:NSKeyValueObservingOptionNew context:nil];
    self.account = @"ReactiveObjC";
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
    self.loginView.loginButton.rac_command = self.userViewModel.loginCommand;
    @weakify(self);
    [_userViewModel.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        @strongify(self);
        self.loginView.statusLabel.text = @"登录中...";
        self.infoView.nicknameLabel.text = @"";
        self.infoView.genderLabel.text = @"";
        
        [loginSignal subscribeNext:^(NSString *messge) {
            NSLog(@"\n%s\n%@", __func__, messge);
            @strongify(self);
            self.loginView.statusLabel.text = @"登录成功";
            self.infoView.nicknameLabel.text = self.userViewModel.userModel.username;
            self.infoView.genderLabel.text = self.userViewModel.userModel.gender;
        }];
    }];
    //.errors错误信号订阅nextBlock
    [_userViewModel.loginCommand.errors subscribeNext:^(NSError *error) {
        NSLog(@"\n%s\n%@", __func__, error);
        @strongify(self);
        self.loginView.statusLabel.text = @"登录失败";
        self.infoView.nicknameLabel.text = @"";
        self.infoView.genderLabel.text = @"";
    }];
}

#pragma mark - KVO Methods
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSString *account = change[NSKeyValueChangeNewKey];
    NSLog(@"\n%s\naccount:%@", __func__, account);
}

#pragma mark - Setter && Getter Methods
- (MKLoginView *)loginView {
    if (!_loginView) {
        _loginView = [[MKLoginView alloc] init];
    }
    return _loginView;
}

- (MKInfoView *)infoView {
    if (!_infoView) {
        _infoView = [[MKInfoView alloc] init];
    }
    return _infoView;
}

- (MKUserViewModel *)userViewModel {
    if (!_userViewModel) {
        _userViewModel = [[MKUserViewModel alloc] init];
    }
    return _userViewModel;
}
@end
