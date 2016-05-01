//
//  ZLShareViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 5/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLShareViewController.h"
#import "ZLShareView.h"
#import "WXApi.h"
@interface ZLShareViewController ()<ShareDelegate>

@property (nonatomic,strong) ZLShareView *shareView;
@property (nonatomic,copy) NSString *strTitle;
@property (nonatomic,copy) NSString *strUrl;
@end

@implementation ZLShareViewController

- (id)initWithTitle:(NSString*)title url:(NSString *)url
{
    self = [super init];
    
    _strTitle = title;
    _strUrl = url;
    
    return self;
}
-(void)show
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    [UIView commitAnimations];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shareView = [[ZLShareView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:_shareView];
    _shareView.frame = Rect(0, 0, kScreenWidth, kScreenHeight);
    _shareView.delegate = self;
    
}

- (void)shareWeChat:(int)nType
{
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = nType;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = @"99乐投";//分享标题
    urlMessage.description = _strTitle;//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"bigest_logo.png"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = _strUrl;//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    //发送分享信息
    [WXApi sendReq:sendReq];
}

- (void)shareIndex:(NSInteger)index
{
    switch (index) {
        case 1:
        {
            [self shareWeChat:0];
        }
            break;
        case 2:
            [self shareWeChat:1];
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
            
    }
}

- (void)hiddenView
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
