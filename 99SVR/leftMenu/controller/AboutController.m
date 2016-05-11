//
//  AboutController.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/24.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//  关于我们

#import "AboutController.h"
#import "NNSVRViewController.h"

@interface AboutController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation AboutController

static NSUInteger const AboutFooterViewHeight = 60; // 底部高度

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleText:@"关于我们"];
    
    self.view.backgroundColor = COLOR_Bg_Gay;
    [self setupTableView];
}

#pragma mark - 初始化界面

- (void)setupTableView
{
    _tableView= [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64 - AboutFooterViewHeight) style:UITableViewStyleGrouped];;
    _tableView.dataSource = self;
    _tableView.delegate=self;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [UIView new];
    _tableView.backgroundColor = COLOR_Bg_Gay;
    [_tableView setSeparatorColor:COLOR_Line_Small_Gay];
    [self.view addSubview:_tableView];
    
    // 版权所有
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - AboutFooterViewHeight, kScreenWidth, AboutFooterViewHeight)];
    
    // 版权
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.font = Font_12;
    copyrightLabel.text = @"99乐投 版权所有";
    copyrightLabel.textColor = COLOR_Text_Gay;
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    copyrightLabel.frame = CGRectMake(0,10, kScreenWidth, 20);
    [footerView addSubview:copyrightLabel];
    
    // 版权说明
    UILabel *copyrightDescLabel = [[UILabel alloc] init];
    copyrightDescLabel.font = Font_12;
    copyrightDescLabel.text = @"copyright @ 2015-2016 99letou.All Rights Reserved.";
    copyrightDescLabel.textColor = COLOR_Text_Gay;
    copyrightDescLabel.textAlignment = NSTextAlignmentCenter;
    copyrightDescLabel.frame = CGRectMake(0, CGRectGetMaxY(copyrightLabel.frame), kScreenWidth, 20);
    [footerView addSubview:copyrightDescLabel];
    
    [self.view addSubview:footerView];
}

- (UIView *)tableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    // logo
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"set_about_logo"];
    logoImageView.size = (CGSize){90,90};
    logoImageView.centerX = headerView.centerX;
    logoImageView.y = 30;
    [headerView addSubview:logoImageView];
    
    // 版本号
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.font = Font_14;
    versionLabel.textColor = COLOR_Text_Black;
#ifdef DEBUG
    char cString[255];
    const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
    const char *bundle = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] UTF8String];
    sprintf(cString, "版本 V%s,build:%s",version,bundle);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    versionLabel.text = objCString;
    objCString = nil;
#else
    char cString[255];
    const char *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] UTF8String];
    sprintf(cString, "版本 V%s",version);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    versionLabel.text = objCString;
    objCString = nil;
#endif
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.frame = CGRectMake(0, CGRectGetMaxY(logoImageView.frame)+5, kScreenWidth, 25);
    [headerView addSubview:versionLabel];
    
    // 网址地址
    UILabel *urlLabel = [[UILabel alloc] init];
    urlLabel.font = Font_14;
    urlLabel.text = @"www.99ducaijing.com";
    urlLabel.textColor = COLOR_Text_038CFF;
    urlLabel.textAlignment = NSTextAlignmentCenter;
    urlLabel.frame = CGRectMake(0, CGRectGetMaxY(versionLabel.frame), kScreenWidth, 25);
    [headerView addSubview:urlLabel];
    
    return headerView;
}

#pragma mark - tableviewdelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    NSInteger row=indexPath.row;
    switch (row) {
        case 0:
        {
            cell.textLabel.text=@"使用条款及隐私政策";
            cell.detailTextLabel.text = @"";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        case 1:
        {
            cell.textLabel.text=@"给乐投评分";
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        }
            break;
        default:
            break;
    }
    cell.textLabel.textColor=COLOR_Text_Black;
    cell.textLabel.font = Font_14;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row=indexPath.row;
    if (row == 0) {
        [self openHttp];
    } else if (row == 1){
        // 去评分
        NSString *str = [NSString stringWithFormat:
                         @"itms-apps://itunes.apple.com/cn/app/id%@?mt=8", @""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

- (void)openHttp
{
    NNSVRViewController *nnView = [[NNSVRViewController alloc] initWithPath:@"http://www.99ducaijing.com/phone/appyhxy.aspx" title:@"使用条款及隐私政策"];
    [self.navigationController pushViewController:nnView animated:YES];
}

@end
