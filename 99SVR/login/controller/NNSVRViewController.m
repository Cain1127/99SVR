//
//  NNSVRViewController.m
//  99SVR
//  99乐投协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NNSVRViewController.h"
#import "AdaptiveWebView.h"

@interface NNSVRViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) AdaptiveWebView *adaptiveWebView;

@end

@implementation NNSVRViewController

- (id)initWithPath:(NSString *)strPath title:(NSString *)strTitle
{
    if(self = [super init])
    {
        _strPath = strPath;
        _strTitle = strTitle;
        return self;
    }
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_strTitle];

    _adaptiveWebView = [[AdaptiveWebView alloc] initWithFrame:Rect(0.0f, 64.0f, kScreenWidth, kScreenHeight - 64.0f)];
    _adaptiveWebView.url = _strPath;

    [self.view addSubview:_adaptiveWebView];
}

- (void)dealloc
{
    _adaptiveWebView = nil;
}



@end
