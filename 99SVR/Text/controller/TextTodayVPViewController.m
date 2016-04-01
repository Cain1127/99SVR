//
//  TextTodayVPViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/4/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextTodayVPViewController.h"
#import "TextTcpSocket.h"
#import "Toast+UIView.h"
#import "MJRefresh.h"
#import "LiveCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "LiveCoreTextCell.h"
#import "TextLiveModel.h"
#import "DTCoreText.h"

@interface TextTodayVPViewController ()<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,ThumCellDelagate>
{
    NSCache *cellCache;
    NSMutableDictionary *dict;
}
@property (nonatomic) int nCurrent;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *aryLive;
@property (nonatomic,strong) TextTcpSocket *tcpSocket;

@end

@implementation TextTodayVPViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket
{
    self = [super init];
    _tcpSocket = tcpSocket;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitleText:@"直播重点"];
    [self initUIHead];
    dict = [NSMutableDictionary dictionary];
    [self requestPoint];
}

- (void)requestPoint
{
    [_tcpSocket reqTextRoomList:0 count:20 type:2];
    _nCurrent += 20;
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth,kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestInfo)];
}

- (void)requestInfo
{
    [_tcpSocket reqTextRoomList:0 count:20 type:2];
    _nCurrent = 20;
}

- (void)requestMore
{
//    __weak TextTodayVPViewController *__self = self;
    [_tcpSocket reqTextRoomList:_nCurrent count:20 type:2];
    _nCurrent += 20;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryLive.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryLive.count>indexPath.section)
    {
        LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    NSMutableArray *aryIndex = [NSMutableArray array];
    Photo *_photo = [[Photo alloc] init];
    _photo.nId = 0;
    _photo.imgName = imageView.image;
    [aryIndex addObject:_photo];
    PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
    [photoControl show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if([attachment.contentURL.absoluteString isEqualToString:@"text_live_ask_icon"])
        {
            [imageView setImage:[UIImage imageNamed:@"text_live_ask_icon"]];
        }
        else if([attachment.contentURL.absoluteString isEqualToString:@"text_live_answer_icon"])
        {
            [imageView setImage:[UIImage imageNamed:@"text_live_answer_icon"]];
        }
        else
        {
            [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {}];
        }
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        NSURL *url1 = [[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"];
        [imageView sd_setImageWithURL:url1];
        return imageView;
    }
    return nil;
}

- (void)liveCore:(LiveCoreTextCell *)liveCore msgid:(int64_t)messageid
{
    if (liveCore.btnThum.selected)
    {
        return ;
    }
    [_tcpSocket reqZans:messageid];
    liveCore.btnThum.selected = YES;
    [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
}

- (LiveCoreTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    TextLiveModel *textModel = [_aryLive objectAtIndex:indexPath.section];
    strInfo = textModel.strContent;
    LiveCoreTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextLiveIdentifier"];
    if (cell==nil)
    {
        cell = [[LiveCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextLiveIdentifier"];
    }
    cell.textCoreView.delegate = self;
    cell.textCoreView.shouldDrawImages = YES;
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.textCoreView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
   
//    [cell.lblTime setText:NSStringFromInt64(textModel.messagetime)];
    cell.section = indexPath.section;
    
    [cell setTextModel:textModel];
    
    CGFloat fHeight = [cell.textCoreView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    [cellCache setObject:NSStringFromFloat(fHeight) forKey:cacheKey];
    if (textModel.bZan)
    {
        [cell.btnThum setTitle:NSStringFromInt64(textModel.zans+1) forState:UIControlStateNormal];
        cell.btnThum.selected = YES;
    }
    else
    {
        [cell.btnThum setTitle:NSStringFromInt64(textModel.zans) forState:UIControlStateNormal];
        cell.btnThum.selected = NO;
    }
    cell.messageid = textModel.messageid;
    cell.delegate = self;
    return cell;
}

- (void)respTablView
{
    _aryLive = _tcpSocket.aryVIP;
    __weak TextTodayVPViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if ([__self.tableView.header isRefreshing])
        {
            [__self.tableView.header endRefreshing];
        }
        else
        {
            [__self.tableView.footer endRefreshing];
            if (__self.nCurrent != __self.tcpSocket.aryVIP.count)
            {
                [__self.tableView.footer noticeNoMoreData];
                __self.nCurrent = (int)__self.tcpSocket.aryVIP.count;
            }
        }
        [__self.tableView reloadData];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respTablView) name:MESSAGE_TEXT_TODAY_VIP_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respZanSuccess:) name:MESSAGE_TEXT_ZAN_SUC_VC object:nil];
}

- (void)respZanSuccess:(NSNotification *)notify
{
    NSString *messageid = notify.object;
    if (messageid && [dict objectForKey:messageid])
    {
        LiveCoreTextCell *cell =  [dict objectForKey:messageid];
        if(_aryLive.count>cell.section)
        {
            TextLiveModel *textModel = [_aryLive objectAtIndex:cell.section];
            textModel.bZan = YES;
            __weak LiveCoreTextCell *__cell = cell;
            __weak TextTodayVPViewController *__self = self;
            [dict removeObjectForKey:messageid];
            dispatch_async(dispatch_get_main_queue(),
            ^{
               [__self.view makeToast:@"点赞成功"];
               NSInteger message = [__cell.btnThum.titleLabel.text integerValue];
               message++;
               [__cell.btnThum setTitle:NSStringFromInteger(message) forState:UIControlStateNormal];
           });
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextLiveModel *model = [_aryLive objectAtIndex:indexPath.section];
    if (_aryLive.count>indexPath.row)
    {
        DTAttributedTextContentView *content = [DTAttributedTextContentView new];
        content.attributedString = [[NSAttributedString alloc] initWithHTMLData:[model.strContent dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
        CGFloat height = [content suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-80].height;
        return height+80;
    }
    return 0;
}

- (void)dealloc
{
    DLog(@"dealloc");
}

@end
