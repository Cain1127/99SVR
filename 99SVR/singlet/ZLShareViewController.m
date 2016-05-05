//
//  ZLShareViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 5/1/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLShareViewController.h"
#import "ZLShareView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface ZLShareViewController ()<ShareDelegate>

@property (nonatomic,strong) ZLShareView *shareView;
@property (nonatomic,copy) NSString *strTitle;
@property (nonatomic,copy) NSString *strUrl;
@property (nonatomic,strong) TencentOAuth *tencentOAuth;
@end

@implementation ZLShareViewController


- (void)responseDidReceived:(APIResponse*)response forMessage:(NSString *)message
{
    DLog(@"message:%@",message);
}

- (id)initWithTitle:(NSString*)title url:(NSString *)url
{
    self = [super init];
    
    _strTitle = title;
    _strUrl = url;
    
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1105298719" andDelegate:self];
    
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
    if (![WXApi isWXAppInstalled])
    {
        [ProgressHUD showError:@"没有安装微信,无法分享"];
        return ;
    }
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

- (void)shareQQChat
{
    if (![TencentOAuth iphoneQQInstalled])
    {
        [ProgressHUD showError:@"没有安装QQ,无法分享"];
        return ;
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigest_logo@2x" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    QQApiURLObject *urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:_strUrl] title:@"99乐投" description:_strTitle previewImageData:data targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
    //将内容分享到qq
    [QQApiInterface sendReq:req];

}

- (void)shareFriend{
    if (![WeiboSDK isWeiboAppInstalled]) {
        [ProgressHUD showError:@"没有安装微博,无法分享"];
        return ;
    }
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI =kRedirectURI;
    authRequest.scope =@"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:kSinaKey];
    request.userInfo =@{@"ShareMessageFrom":@"ZLShareViewController",
                        @"Other_Info_1": [NSNumber numberWithInt:123],
                        @"Other_Info_2": @[@"obj1",@"obj2"],
                        @"Other_Info_3":@{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (WBMessageObject *)messageToShare
{
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"99乐投";
    webpage.description = [NSString stringWithFormat:_strTitle, [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigest_logo@2x" ofType:@"png"]];
    webpage.webpageUrl =_strUrl;
    message.mediaObject = webpage;
    return message;
}

- (void)shareQQZone
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigest_logo@2x" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    QQApiURLObject *urlObj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:_strUrl] title:@"99乐投" description:_strTitle previewImageData:data targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObj];
    //将内容分享到qq
    [QQApiInterface SendReqToQZone:req];
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
            [self shareQQChat];
            break;
        case 4:
            [self shareQQZone];
            break;
        case 5:
            [self shareFriend];
            break;
        case 6:
        {
            UIPasteboard *pboard = [UIPasteboard generalPasteboard];
            pboard.string = _strUrl;
            [ProgressHUD showSuccess:@"复制成功"];
        }
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
