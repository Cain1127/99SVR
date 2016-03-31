//
//  NNSVRViewController.m
//  99SVR
//  99财经协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NNSVRViewController.h"

@interface NNSVRViewController ()

@property (nonatomic,strong) UIWebView *webView;

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

    _webView = [[UIWebView alloc] initWithFrame:Rect(0.0f, 64.0f, kScreenWidth, kScreenHeight - 64.0f)];
    [self.view addSubview:_webView];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_strPath]];
    [_webView loadRequest:request];
}

@end
