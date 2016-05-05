//
//  XTeamViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/21/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "ZLRoomVideoCell.h"
#import "TableViewFactory.h"
#import "XVideoTeamInfo.h"

@interface XTeamViewController()<DTAttributedTextContentViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSCache *cache;
}
@property (nonatomic,strong) NSArray *aryVideo;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy) NSString *introduce;
@property (nonatomic,strong) RoomHttp *room;

@end

@implementation XTeamViewController

- (id)initWithModel:(RoomHttp *)room
{
    self = [super init];
    _room = room;
    cache = [[NSCache alloc] init];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"讲师团队简介"];
    [self.headView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 185)];
    [self.view insertSubview:imgView atIndex:0];

    char cBuffer[100]={0};
    sprintf(cBuffer,"video_profiles_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [imgView sd_setImageWithURL:url1];
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenWidth/2-32.5,64,65,65)];
    [self.view addSubview:imgHead];
    imgHead.layer.masksToBounds = YES;
    imgHead.layer.cornerRadius = 32;
    NSString *strUrl = [NSString stringWithFormat:@"%@",_room.croompic];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, 160, kScreenWidth, 20)];
    [lblName setTextColor:UIColorFromRGB(0xffffff)];
    [lblName setText:_room.teamname];
    [lblName setFont:XCFONT(15)];
    [lblName setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:lblName];

    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 185, kScreenWidth, kScreenHeight-185) withStyle:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView setBackgroundColor:UIColorFromRGB(0xffffff)];
}

- (void)loadVideoInfo:(NSNotification *)notify
{
    NSDictionary *parametesrs = notify.object;
    if ([parametesrs isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [parametesrs[@"code"] intValue];
        NSArray *aryTemp = parametesrs[@"data"];
        if (nStatus==1)
        {
            _aryVideo = aryTemp;
        }
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [selfWeak.tableView reloadData];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTeamContent:) name:MESSAGE_TEAM_INTRODUCE_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadVideoInfo:) name:MESSAGE_ROOM_VIDEO_LIST_VC object:nil];
    [kHTTPSingle RequestTeamIntroduce:[_room.teamid intValue]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadTeamContent:(NSNotification *)notify
{
    NSDictionary *parametesrs = notify.object;
    if ([parametesrs isKindOfClass:[NSDictionary class]])
    {
        int nStatus = [parametesrs[@"code"] intValue];
        if (nStatus==1) {
            XVideoTeamInfo *teamInfo = parametesrs[@"data"];
            _introduce = [NSString stringWithFormat:@"<span stype=\"line-height:17px;\">%@</span>",teamInfo.introduce];
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
//                [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [selfWeak.tableView reloadData];
            });
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }
    NSInteger count = (NSInteger)ceilf((1.0f * _aryVideo.count) / 2.0f);
    return count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+(_aryVideo.count ? 1 : 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *nameView = [[UIView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 44)];
    [nameView setBackgroundColor:UIColorFromRGB(0xffffff)];
    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(10, 0, 100, 44)];
    [lblName setFont:XCFONT(16)];
    lblName.text = section == 0 ? @"擅长" : @"精彩课程";
    [nameView addSubview:lblName];
    return nameView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        DTAttributedTextCell *cell =[cache objectForKey:@"RoomTeamCell"];
        if (!cell) {
            cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:@"RoomTeamCell"];
           
            [cache setObject:cell forKey:@"RoomTeamCell"];
        }
        [cell setHTMLString:_introduce];
        return cell;
    }
    ZLRoomVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamVideoCell"];
    if (!cell)
    {
        cell = [[ZLRoomVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamVideoCell"];;
    }

    cell.itemOnClick = ^(XVideoModel *room)
    {
        
    };
    int length = 2;
    int loc = (int)indexPath.row * length;
    if (loc + length > _aryVideo.count)
    {
        length = (int)_aryVideo.count - loc;
    }
    NSRange range = NSMakeRange(loc, length);
    NSArray *aryIndex = [_aryVideo subarrayWithRange:range];
    [cell setRowDatas:aryIndex];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        DTAttributedTextCell *cell = (DTAttributedTextCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return [cell requiredRowHeightInTableView:tableView];
    }
    else
    {
        CGFloat height = ((kScreenWidth - 36.0f) / 2.0f) * 10 / 16 + 8;
        return height;
    }
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
