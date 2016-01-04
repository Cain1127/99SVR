//
//  AboutController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//  关于我们

#import "AboutController.h"

@implementation AboutController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultHeader:@"关于我们"];
    [self initSubviews];
}

- (void)initSubviews {
    self.view.backgroundColor = RGB(243, 243, 243);
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bigest_logo"]];
    [self.view addSubview:logoImageView];
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = kFontSize(17);
    versionLabel.textColor = [UIColor colorWithHex:@"#343434"];
    versionLabel.text = [NSString stringWithFormat:@"版本 V%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    [self.view addSubview:versionLabel];
    
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(108 + 64);
        make.centerX.equalTo(self.view);
    }];
    
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(logoImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
}

@end
