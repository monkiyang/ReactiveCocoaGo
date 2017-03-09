//
//  MKInfoView.m
//  ReactiveCocoaGo
//
//  Created by YangMengqi on 2017/3/9.
//  Copyright © 2017年 YangMengqi. All rights reserved.
//

#import "MKInfoView.h"

@interface MKInfoView()
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *genderLabel;
@end

@implementation MKInfoView

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupSubviews];
    }
    return self;
}

#pragma mark - Private Methods
- (void)setupSubviews {
    [self addSubview:self.nicknameLabel];
    
    _nicknameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"nicknameLabel": _nicknameLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[nicknameLabel]" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nicknameLabel]|" options:0 metrics:nil views:views]];
    
    [self addSubview:self.genderLabel];
    _genderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    views = @{@"nicknameLabel": _nicknameLabel, @"genderLabel": _genderLabel};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nicknameLabel][genderLabel]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
}

#pragma mark - Setter && Getter Methods
- (UILabel *)nicknameLabel {
    if (!_nicknameLabel) {
        _nicknameLabel = [[UILabel alloc] init];
        _nicknameLabel.font = [UIFont systemFontOfSize:14.];
        _nicknameLabel.textColor = [UIColor blackColor];
    }
    return _nicknameLabel;
}

- (UILabel *)genderLabel {
    if (!_genderLabel) {
        _genderLabel = [[UILabel alloc] init];
        _genderLabel.font = [UIFont systemFontOfSize:14.];
        _genderLabel.textColor = [UIColor blackColor];
    }
    return _genderLabel;
}
@end
