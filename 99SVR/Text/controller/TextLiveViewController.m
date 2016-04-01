//
//  TextLiveViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveViewController.h"
#import "LiveCoreTextCell.h"
#import "NewDetailsViewController.h"
#import "Toast+UIView.h"
#import "TextLiveModel.h"
#import "textTcpSocket.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#import "MJRefresh.h"
#import "ThumButton.h"
#import "TeacherModel.h"
#import "MarchLiveTextCell.h"

@interface TextLiveViewController ()<UITableViewDataSource,UITableViewDelegate,DTAttributedTextContentViewDelegate,MarchLiveTextDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
    NSMutableDictionary *dict;
}

@property (nonatomic) int nCurrent;
@property (nonatomic,copy) NSArray *aryLive;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) TextTcpSocket *textSocket;

@end

@implementation TextLiveViewController

- (id)initWithSocket:(TextTcpSocket *)textSocket
{
    if(self = [super  init])
    {
        cellCache = [[NSCache alloc] init];
        _textSocket = textSocket;
        return self;
    }
    return nil;
}

- (void)initData
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    _aryLive = [NSMutableArray array];
    dict = [NSMutableDictionary dictionary];
    [self initData];
    [self initTabelView];
}

- (void)initTabelView
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableView.footer.appearencePercentTriggerAutoRefresh = 300.0;
    [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(requestTextLive)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMoreTextLive)];
    [_tableView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [_tableView.gifHeader loadDefaultImg];
}

- (void)requestMoreTextLive
{
    [_tableView.footer beginRefreshing];
    [_textSocket reqTextRoomList:_nCurrent count:20 type:1];
     _nCurrent += 20;
}

- (void)requestTextLive
{
    _aryLive = _textSocket.aryText;
    DLog(@"重新加载");
    __weak UITableView *__table = _tableView;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__table reloadData];
        [__table.header beginRefreshing];
        [__table.footer resetNoMoreData];
    });
    _nCurrent = 0;
    [_textSocket reqTextRoomList:_nCurrent count:20 type:1];
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
        MarchLiveTextCell *cell = [self tableView:tableView marchCellForIndexPath:indexPath];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarchLiveTextCell *cell = [self tableView:tableView marchCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView]+66;
}

- (MarchLiveTextCell *)tableView:(UITableView *)tableView marchCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    TextLiveModel *textModel = [_aryLive objectAtIndex:indexPath.section];
    strInfo = textModel.strContent;
    MarchLiveTextCell *cell = [cellCache objectForKey:cacheKey];
    if (cell==nil)
    {
        cell = [[MarchLiveTextCell alloc] initWithReuseIdentifier:@"TextLiveIdentifier"];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = selectView;
        [cellCache setObject:cell forKey:cacheKey];
    }
    [cell setHTMLString:strInfo];
    cell.section = indexPath.section;
    [cell setTextModel:textModel];
    cell.messageid = textModel.messageid;
    cell.attributedTextContextView.delegate = self;
    cell.delegate = self;
    return cell;
}

- (void)textLive:(MarchLiveTextCell *)liveCore msgid:(int64_t)messageid
{
    if([liveCore.btnThum.titleLabel.text isEqualToString:@"详情>>>"])
    {
        NewDetailsViewController *newView = [[NewDetailsViewController alloc] initWithSocket:_textSocket viewID:liveCore.viewid];
        [self.navigationController pushViewController:newView animated:YES];
    }
    else
    {
        if (liveCore.btnThum.selected)
        {
            return ;
        }
        [_textSocket reqZans:messageid];
        liveCore.btnThum.selected = YES;
        [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
    }
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger row = [indexPath section];
//    TextLiveModel *textModel = [_aryLive objectAtIndex:row];
//    DLog(@"content:%@",textModel.strContent);
}

- (void)reLoadTextList
{
    _aryLive = _textSocket.aryText;
    DLog(@"重新加载");
    __weak TextLiveViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        if ([__self.tableView.header isRefreshing])
        {
            [__self.tableView.header endRefreshing];
        }
        else
        {
            [__self.tableView.footer endRefreshing];
            if (__self.nCurrent != __self.textSocket.aryText.count)
            {
                [__self.tableView.footer noticeNoMoreData];
                __self.nCurrent = (int)__self.textSocket.aryText.count;
            }
        }
        [__self.tableView reloadData];
    });
}

- (void)reqTextList
{
    if (_nCurrent==0)
    {
        [_textSocket.aryChat removeAllObjects];
    }
    [_textSocket reqTextRoomList:_nCurrent count:20 type:1];
    _nCurrent += 20;
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
            __weak TextLiveViewController *__self = self;
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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadTextList) name:MESSAGE_TEXT_LOAD_TODAY_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reqTextList) name:MESSAGE_TEXT_TEACHER_INFO_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respZanSuccess:) name:MESSAGE_TEXT_ZAN_SUC_VC object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
