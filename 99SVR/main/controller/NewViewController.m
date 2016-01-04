//
//  NewViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 12/8/15.
//  Copyright © 2015 xia zhonglin . All rights reserved.
//

#import "NewViewController.h"
#import "GroupView.h"
#import "HtmlRoomViewCell.h"
#import "UIImageView+WebCache.h"
#import "Toast+UIView.h"
#import "LSTcpSocket.h"
#import "UserInfo.h"
#import "moonDefines.h"
#import "HtmlRoom.h"
#import "RoomViewController.h"

#define HTTP_ROOM_LIST_URL @"http://hall.99ducaijing.cn:8081/room6.php"

@interface RoomSmall : NSObject

@property (nonatomic,copy) NSString *strName;
@property (nonatomic,assign) int nId;

@end

@implementation RoomSmall
@end

@interface NewViewController () <UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
}

@property (nonatomic,strong) UIView *blackView;
@property (nonatomic,strong) NSMutableArray *aryGroup;
@property (nonatomic,strong) UIWebView *webView;
@property (nonatomic,strong) GroupView *group;
@property (nonatomic,strong) GroupView *sonGroup;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation NewViewController

- (void)initUIHead
{
    [self setTitleText:@"房间列表"];
    
    _group = [[GroupView alloc] initWithFrame:Rect(0, 64, kScreenWidth, 44)
                                          ary:[[UserInfo sharedUserInfo].dictRoomInfo allKeys]];
    [self.view addSubview:_group];
    
    
}

- (void)initUIBody
{
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, _group.y+_group.height, kScreenWidth, kScreenHeight-(_group.y+_group.height))];
    
    [self.view addSubview:_tableView];
    
    [_tableView setDelegate:self];
    
    [_tableView setDataSource:self];
    
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    int tag[3];
    int nCount = (int)[[UserInfo sharedUserInfo].dictRoomInfo allKeys].count;
    NSArray *aryKey = [[UserInfo sharedUserInfo].dictRoomInfo allKeys];
    for (int j=0; j<nCount; j++) {
        NSValue *value = [[UserInfo sharedUserInfo].dictRoomInfo objectForKey:aryKey[j]];
        RoomGroupData_t groupData;
        memset(&groupData, 0, sizeof(RoomGroupData_t));
        [value getValue:&groupData];
        tag[j]=groupData.groupid;
        
    }
    [_group setBtnTag:tag[0] tag1:tag[1] tag2:tag[2]];
    
    NSMutableArray *aryName = [NSMutableArray array];
    char cBuf[16];
    memset(cBuf, 0, 16);
    int i=0;
    for (NSValue *value in [UserInfo sharedUserInfo].aryRoomInfo)
    {
        RoomGroupData_t groupData;
        memset(&groupData, 0, sizeof(RoomGroupData_t));
        [value getValue:&groupData];
        NSStringEncoding gbkEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSString *strName = [NSString stringWithCString:groupData.groupname encoding:gbkEncoding];
        [aryName addObject:strName];
        tag[i]=groupData.groupid;
        DLog(@"groupId:%d---strName:%@",tag[i],strName);
        i++;
    }
    _sonGroup = [[GroupView alloc] initWithFrame:Rect(0, _group.y+_group.height, kScreenWidth, 44) ary:aryName];
    
    [_sonGroup setBtnTag:tag[0] tag1:tag[1] tag2:tag[2]];
    
    [self.view addSubview:_sonGroup];
    
    _sonGroup.hidden = YES;
    
    _webView = [[UIWebView alloc] initWithFrame:Rect(0, _group.y+_group.height, kScreenWidth, kScreenHeight-(_group.y+_group.height))];
    
    [_webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://hall.99ducaijing.cn:8081/room6.php?groupid=4&stealth=&time=1448531774"]]];
    
    _webView.delegate = self;
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    _aryGroup = [NSMutableArray array];
    
    [self initUIHead];
    [self initUIBody];
    __weak NewViewController *__self = self;
    [_group addEventForHot:^(id sender)
    {
        UIButton *btnSender = sender;
        [__self setSonGroupInfo:YES];
        NSString *strUrl = [NSString stringWithFormat:@"%@?groupid=%d&stealth=&time=%lu",HTTP_ROOM_LIST_URL,(int)btnSender.tag,time(0)];
        [__self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]];
    }];
    
    [_group addEventForGroup:^(id sender)
    {
        [__self setSonGroupInfo:NO];
    }];
    
    [_group addEventForHelp:^(id sender) {
        UIButton *btnSender = sender;
        [__self setSonGroupInfo:YES];
        NSString *strUrl = [NSString stringWithFormat:@"%@?groupid=%d&stealth=&time=%lu",HTTP_ROOM_LIST_URL,(int)btnSender.tag,time(0)];
        [__self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]];
    }];
    
    [_sonGroup addEventForHot:^(id sender)
     {
        [__self sendBtnSon:(UIButton *)sender];
     }];
    
    [_sonGroup addEventForGroup:^(id sender)
     {
        [__self sendBtnSon:(UIButton *)sender];
     }];
    
    [_sonGroup addEventForHelp:^(id sender) {
        [__self sendBtnSon:(UIButton *)sender];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomSucess) name:MESSAGE_JOIN_ROOM_SUC_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinRoomFail:) name:MESSAGE_JOIN_ROOM_ERR_VC object:nil];
}

- (void)joinRoomFail:(NSNotification*)notify
{
    NSString *strNotify = notify.object;
    __block NSString *__strNotify = strNotify;
    __weak NewViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:__strNotify delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    });
}

- (void)joinRoomSucess
{
    __weak NewViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.view hideToastActivity];
        RoomViewController *roomView = [[RoomViewController alloc] init];
        [__self presentViewController:roomView animated:YES completion:nil];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendBtnSon:(UIButton *)sender
{
    [self setSonGroupInfo:YES];
    NSString *strUrl = [NSString stringWithFormat:@"%@?groupid=%d&stealth=&time=%lu",HTTP_ROOM_LIST_URL,(int)sender.tag,time(0)];
    DLog(@"strUrl:%@",strUrl);
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]]];
}

- (void)setSonGroupInfo:(BOOL)bFlag
{
    _sonGroup.hidden = bFlag;
    if (bFlag)
    {
        _tableView.frame = Rect(0, _group.y+_group.height, kScreenWidth, kScreenHeight- (_group.y+_group.height));
    }
    else
    {
        _tableView.frame = Rect(0, _sonGroup.y+_sonGroup.height, kScreenWidth, kScreenHeight- (_sonGroup.y+_sonGroup.height));
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //返回YES，进行加载。通过UIWebViewNavigationType可以得到请求发起的原因
    return YES;
}

- (void)getRoomInfo:(NSURL *)url
{
    NSArray *aryRoom = [url.absoluteString componentsSeparatedByString:@";"];
    NSString *strId = [[aryRoom  objectAtIndex:0] stringByReplacingOccurrencesOfString:@"tryroom://" withString:@""];
    
    LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
    
    NSArray *aryAddress = [[aryRoom objectAtIndex:1] componentsSeparatedByString:@":"];
    
    [socket connectRoomInfo:strId address:[aryAddress objectAtIndex:0] port:[[aryAddress objectAtIndex:1] intValue]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //开始加载，可以加上风火轮
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *bodyStyleHorizontal = @"document.getElementsByTagName('a').length";
    int nLength = [[webView stringByEvaluatingJavaScriptFromString:bodyStyleHorizontal] intValue];
    
    [_aryGroup removeAllObjects];
    
    for (int i=0; i<nLength; i++)
    {
        NSString *htmlA = [NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].href",i];
        NSString *htmlTitle = [NSString stringWithFormat:@"document.getElementsByTagName('a')[%d].title",i];
        NSString *htmlSrc = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src",i];
        
        NSString *strArr = [webView stringByEvaluatingJavaScriptFromString:htmlA];
        NSString *strTitle = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
        NSString *strSrc = [webView stringByEvaluatingJavaScriptFromString:htmlSrc];
        NSArray *aryRoom = [strArr componentsSeparatedByString:@";"];
        
        NSString *strId = [[aryRoom  objectAtIndex:0] stringByReplacingOccurrencesOfString:@"tryroom://" withString:@""];
        
        NSArray *aryAddress = [[aryRoom objectAtIndex:1] componentsSeparatedByString:@":"];
        HtmlRoom *room = [[HtmlRoom alloc] init];
        room.strRoomId = strId;
        room.strRoomName = strTitle;
        room.strAddress = aryAddress[0];
        room.nPort = [aryAddress[1] intValue];
        room.strUrl = strSrc;
        
        [_aryGroup addObject:room];
    }
    __weak NewViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [__self.tableView reloadData];
    });
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载出错
}

#pragma mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryGroup.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strIdentifier = @"NEWVIEWTABLEVIEWCELL_IDENTIFIER";
    
    HtmlRoomViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if(cell==nil)
    {
        cell = [[HtmlRoomViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    HtmlRoom *room = [_aryGroup objectAtIndex:indexPath.row];
    
    [cell setCellInfo:room];
    
    return cell;
}

#pragma mark delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view makeToastActivity];

    HtmlRoom *room = [_aryGroup objectAtIndex:indexPath.row];
    
    LSTcpSocket *socket = [LSTcpSocket sharedLSTcpSocket];
    
    [socket connectRoomInfo:room.strRoomId address:room.strAddress port:room.nPort];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

@end
