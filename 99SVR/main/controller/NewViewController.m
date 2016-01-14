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

@end
