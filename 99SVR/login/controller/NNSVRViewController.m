//
//  NNSVRViewController.m
//  99SVR
//  99乐投协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NNSVRViewController.h"
#import "AdaptiveWebView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "StockDealViewController.h"
#import "StockDealModel.h"

@interface NNSVRViewController ()<AdaptiveWebViewDelegate>

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

- (void)requestOperater:(NSString *)strId name:(NSString *)strName
{
    StockDealViewController *dealView = [[StockDealViewController alloc] init];
    StockDealModel *stockModel = [[StockDealModel alloc] init];
    stockModel.operateid = strId;
    stockModel.teamname = strName;
    dealView.stockModel = stockModel;
    [self.navigationController pushViewController:dealView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:_strTitle];

    _adaptiveWebView = [[AdaptiveWebView alloc] initWithFrame:Rect(0.0f, 64.0f, kScreenWidth, kScreenHeight - 64.0f)];
    _adaptiveWebView.url = _strPath;
    _adaptiveWebView.delegate = self;
    [self.view addSubview:_adaptiveWebView];
}

- (void)dealloc
{
    _adaptiveWebView = nil;
}


@end
