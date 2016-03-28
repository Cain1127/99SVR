//
//  TextHistroyViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 3/5/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//
#import "TextHistoryViewController.h"
#import "TextTcpSocket.h"
#import "NSDate+Convenience.h"
#import "NewDetailsViewController.h"
#import "Toast+UIView.h"
#import "MJRefresh.h"
#import "LiveCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "UIImageView+WebCache.h"
#import "LiveCoreTextCell.h"
#import "TextLiveModel.h"

#define kOne_Day_Time 24*60*60

@interface TextHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate,ThumCellDelagate>
{
    NSCache *cellCache;
    NSMutableDictionary *dict;
    NSDateFormatter *fmt;
    NSDate *currentDate;
    NSTimeInterval currentTime;
    UIView *downView;
}
@property (nonatomic) int nCurrent;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryHistory;
@property (nonatomic,strong) TextTcpSocket *tcpSocket;
@property (nonatomic,strong) UIButton *btnNext;
@property (nonatomic,strong) UIButton *btnPrevious;

@end

@implementation TextHistoryViewController

- (id)initWithSocket:(TextTcpSocket *)tcpSocket
{
    self = [super init];
    _tcpSocket = tcpSocket;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setTitleText:@"直播重点"];
    fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy年MM月dd日"];
    currentTime = -kOne_Day_Time;
    currentDate = [NSDate dateWithTimeIntervalSinceNow:currentTime];
//    [self setTitleText:[fmt stringFromDate:currentDate]];
    dict = [NSMutableDictionary dictionary];
    [self initUIHead];
    [self requestHistory];
}

- (void)requestHistory
{
    int32_t time = [[NSString stringWithFormat:@"%d%02d%02d",currentDate.year,currentDate.month,currentDate.day] intValue];
    [_tcpSocket reqDayHistoryList:0 count:20 time:time];
    
    _aryHistory = nil;
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    _nCurrent = 20;
}

- (void)navBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initUIHead
{
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [btnBack setImage:[UIImage imageNamed:@"back_high"] forState:UIControlStateHighlighted];
    [btnBack addTarget:self action:@selector(navBack) forControlEvents:UIControlEventTouchUpInside];
    btnBack.frame = Rect(0, 20, 44, 44);
//    [self setLeftBtn:btnBack];
    
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 64, kScreenWidth,kScreenHeight-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMore)];
    
    downView = [[UIView alloc] initWithFrame:Rect(0, kScreenHeight-50, kScreenWidth, 50)];
    [self.view addSubview:downView];
    [downView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    
    UIButton *btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
    [downView addSubview:btnNext];
    
    UIButton *btnPre = [UIButton buttonWithType:UIButtonTypeCustom];
    [downView addSubview:btnPre];
    
    [btnPre setTitle:@"前一天" forState:UIControlStateNormal];
    [btnPre setTitleColor:UIColorFromRGB(0x427ede) forState:UIControlStateNormal];
    [btnPre setFrame:Rect(8, 10, 100, 30)];
    
    [btnNext setTitle:@"后一天" forState:UIControlStateNormal];
    [btnNext setTitleColor:UIColorFromRGB(0x427ede) forState:UIControlStateNormal];
    [btnNext setFrame:Rect(kScreenWidth-108, 10, 100, 30)];
    
    btnPre.tag = 1;
    btnNext.tag = 2;
    [btnPre addTarget:self action:@selector(switchDay:) forControlEvents:UIControlEventTouchUpInside];
    [btnNext addTarget:self action:@selector(switchDay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)switchDay:(UIButton *)sender
{
    int nTemp = 0;
    if (sender.tag==1) {
        nTemp = -kOne_Day_Time;
    }
    else
    {
        nTemp = kOne_Day_Time;
    }
    currentTime += nTemp;
    
    currentDate = [NSDate dateWithTimeIntervalSinceNow:currentTime];
//    [self setTitleText:[fmt stringFromDate:currentDate]];
    [self requestHistory];
}

- (void)requestMore
{
    int32_t time = [[NSString stringWithFormat:@"%d%02d%02d",currentDate.year,currentDate.month,currentDate.day] intValue];
    [_tcpSocket reqDayHistoryList:_nCurrent count:20 time:time];
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
    return _aryHistory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
    return cell;
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
             {
                 
             }];
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
    if ([liveCore.btnThum.titleLabel.text isEqualToString:@"详情>>>"])
    {
        //查看观点
        DLog(@"查看观点");
        NewDetailsViewController *newView = [[NewDetailsViewController alloc] initWithSocket:_tcpSocket viewID:liveCore.viewid];
        [self presentViewController:newView animated:YES completion:nil];
    }
    else
    {
        if (liveCore.btnThum.selected)
        {
            return ;
        }
        [_tcpSocket reqZans:messageid];
        liveCore.btnThum.selected = YES;
        [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
    }
}

- (LiveCoreTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    LiveCoreTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextLiveIdentifier"];
    if (cell==nil)
    {
        cell = [[LiveCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextLiveIdentifier"];
    }
    if (_aryHistory.count > indexPath.section)
    {
        TextLiveModel *textModel = [_aryHistory objectAtIndex:indexPath.section];
        strInfo = textModel.strContent;
        cell.textCoreView.delegate = self;
        cell.textCoreView.shouldDrawImages = YES;
        NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
        cell.textCoreView.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
        
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:[UIColor clearColor]];
        cell.selectedBackgroundView = selectView;
        
//        [cell.lblTime setText:NSStringFromInt64(textModel.messagetime)];
        cell.section = indexPath.section;
        
        CGFloat fHeight = [cell.textCoreView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
        [cellCache setObject:NSStringFromFloat(fHeight) forKey:cacheKey];

        [cell setTextModel:textModel];
       
        cell.messageid = textModel.messageid;
        cell.delegate = self;
    }
    return cell;
}

- (void)respZanSuccess:(NSNotification *)notify
{
    NSString *messageid = notify.object;
    if (messageid && [dict objectForKey:messageid])
    {
        LiveCoreTextCell *cell =  [dict objectForKey:messageid];
        if(_aryHistory.count>cell.section)
        {
            TextLiveModel *textModel = [_aryHistory objectAtIndex:cell.section];
            textModel.bZan = YES;
            __weak LiveCoreTextCell *__cell = cell;
            __weak TextHistoryViewController *__self = self;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTableView) name:MESSAGE_TEXT_HISTORY_LIST_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respZanSuccess:) name:MESSAGE_TEXT_ZAN_SUC_VC object:nil];
}

- (void)loadTableView
{
    _aryHistory = _tcpSocket.aryHistory;
    __weak TextHistoryViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),^{
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextLiveModel *model = [_aryHistory objectAtIndex:indexPath.section];
    if (_aryHistory.count>indexPath.row)
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