//
//  XTeamViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 4/21/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XTeamViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "RoomHttp.h"
#import "XVideoTeamInfo.h"
#import "TableViewFactory.h"

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
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(0, 0, kScreenWidth, 185)];
    char cBuffer[100]={0};
    sprintf(cBuffer,"video_profiles_bg@2x");
    NSString *strName = [NSString stringWithUTF8String:cBuffer];
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"png"];
    [imgView sd_setImageWithURL:url1];
    [self.view addSubview:imgView];
    [super viewDidLoad];
    [self setTitleText:@"讲师团队简介"];
    [self.headView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:UIColorFromRGB(0xffffff)];
    
    UIImageView *imgHead = [[UIImageView alloc] initWithFrame:Rect(kScreenWidth/2-50,64,100,100)];
    [self.view addSubview:imgHead];
    imgHead.layer.masksToBounds = YES;
    imgHead.layer.cornerRadius = 50;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",kIMAGE_HTTP_URL,_room.croompic];
    [imgHead sd_setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"default"]];

    _tableView = [TableViewFactory createTableViewWithFrame:Rect(0, 185, kScreenWidth, kScreenHeight-185) withStyle:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTeamContent:) name:MESSAGE_TEAM_INTRODUCE_VC object:nil];
    [kHTTPSingle RequestTeamIntroduce:0];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadTeamContent:(NSNotification *)notify
{
    XVideoTeamInfo *teamInfo = notify.object;
    if(teamInfo){
        _introduce = [NSString stringWithFormat:@"<span stype=\"line-height:6px;\">%@</span>",teamInfo.introduce];
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            [selfWeak.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1+_aryVideo.count/2;
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
    [lblName setFont:XCFONT(15)];
    lblName.text = section == 0 ? @"擅长" : @"精彩课程";
    [nameView addSubview:lblName];
    return nameView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        DTAttributedTextCell *cell =[cache objectForKey:@"RoomTeamCell"];
        
        if (cell) {
            cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:@"RoomTeamCell"];
            [cache setObject:cell forKey:@"RoomTeamCell"];
        }
        [cell setHTMLString:_introduce];
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamVideoCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TeamVideoCell"];;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if()
    return 60;
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
