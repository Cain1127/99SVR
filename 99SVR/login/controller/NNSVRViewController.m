//
//  NNSVRViewController.m
//  99SVR
//  99乐投协议
//  Created by xia zhonglin  on 1/14/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "NNSVRViewController.h"
#import "AdaptiveWebView.h"
#import "RoomViewController.h"
#import "KxMovieViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "StockDealViewController.h"
#import "StockDealModel.h"
#import "UIViewController+EmpetViewTips.h"

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

#pragma mark - AdaptiveWebViewDelegate

- (void)requestOperater:(NSString *)strId name:(NSString *)strName
{
    StockDealViewController *dealView = [[StockDealViewController alloc] init];
    StockDealModel *stockModel = [[StockDealModel alloc] init];
    stockModel.operateid = strId;
    stockModel.teamname = strName;
    dealView.stockModel = stockModel;
    [self.navigationController pushViewController:dealView animated:YES];
}

- (void)playUrlVideo:(NSString *)htmlPath
{
    [[RoomViewController sharedRoomViewController] stopVideoPlay];
    [self presentViewController:[KxMovieViewController movieViewControllerWithContentPath:htmlPath parameters:nil] animated:YES completion:nil];
}

-(void)AdaptiveWebViewDidFailLoadWithError:(NSError *)error
{
    @WeakObj(self);
    [self showErrorViewInView:_adaptiveWebView withMsg:@"网页加载失败" touchHanleBlock:^{
        @StrongObj(self);
        // URL可能如：@"http://210.56.212.25:80/mobile.php?s=/User/personalSecrets/id/420/uid/1780723/token/1816168D18C1026648F3EA55F70B9C39/client/2";
        // 由于url可能是包含token,如果没网-->有网，token会变，导致url地址打开是过期的。
        // 当前的做法是通过截取token，替换成当前的token
        
        // 1.查找token
        NSString *strCheck = @"";
        if ([_strPath containsString:@"token/"]) {
            NSArray *array = [_strPath componentsSeparatedByString:@"token/"];
            if (array.count > 1) {
                NSArray *arrayResult = [array[1] componentsSeparatedByString:@"/"];
                if (arrayResult.count) {
                    strCheck = arrayResult[0];
                }
            }
        }
        
        DLog(@"strCheck--%@ , strToken--%@",strCheck,[UserInfo sharedUserInfo].strToken);
        // 2.替换token
        if (strCheck.length > 0) {
            _strPath = [_strPath stringByReplacingOccurrencesOfString:strCheck withString:[UserInfo sharedUserInfo].strToken];
        }
        DLog(@"strPath--%@",_strPath);
        
        self.adaptiveWebView.url = _strPath;
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RoomViewController sharedRoomViewController] startVideoPlay];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    DLog(@"87654321");
}

@end
