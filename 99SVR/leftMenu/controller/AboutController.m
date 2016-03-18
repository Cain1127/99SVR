//
//  AboutController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//  关于我们

#import "AboutController.h"

@interface AboutController()
{
    
}
@property (nonatomic,strong) UIImageView *logoImageView;

@end

@implementation AboutController

- (void)dealloc
{
    DLog(@"释放");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultHeader:@"关于我们"];
    [self initSubviews];
}

- (void)initSubviews
{
    self.view.backgroundColor = RGB(243, 243, 243);
    _logoImageView = [[UIImageView alloc] init];
    [self.view addSubview:_logoImageView];
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = kFontSize(17);
    versionLabel.textColor = [UIColor colorWithHex:@"#343434"];
    #ifdef DEBUG
    char cString[255];
    const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
    const char *bundle = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] UTF8String];
    sprintf(cString, "版本 V%s,build:%s",version,bundle);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    versionLabel.text = objCString;
    objCString = nil;
    #else
        char cString[255];
        const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
        sprintf(cString, "版本 V%s",version,bundle);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        versionLabel.text = objCString;
        objCString = nil;
    #endif
    [self.view addSubview:versionLabel];
    __weak AboutController *__self = self;
    dispatch_async(dispatch_get_global_queue(0, 0),
    ^{
        char cString[255];
        const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
        sprintf(cString, "%s/bigest_logo.png",path);
        NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
        UIImage *image = [UIImage imageWithContentsOfFile:objCString];
        if (image)
        {
           dispatch_async(dispatch_get_main_queue(), ^{
               __self.logoImageView.image = image;
           });
        }
    });
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.equalTo(self.view).offset(108 + 64);
        make.centerX.equalTo(self.view);
    }];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.top.mas_equalTo(_logoImageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
    }];
}

@end
