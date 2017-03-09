//
//  LoginView.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()
@end

@implementation LoginView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private Methods
- (void)setupSubviews {
    [self addSubview:self.loginButton];
    
    _loginButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"loginButton": _loginButton};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[loginButton(44.)]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[loginButton(44.)]-(>=0)-|" options:0 metrics:nil views:views]];
    
    [self addSubview:self.statusLabel];
    
    _statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    views = @{@"loginButton": _loginButton , @"statusLabel": _statusLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[loginButton][statusLabel]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
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
