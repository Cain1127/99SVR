//
//  TextLiveViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveViewController.h"
#import "LiveCoreTextCell.h"
#import "Toast+UIView.h"
#import "TextLiveModel.h"
#import "textTcpSocket.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"
#import "MJRefresh.h"
#import "ThumButton.h"

@interface TextLiveViewController ()<UITableViewDataSource,UITableViewDelegate,DTAttributedTextContentViewDelegate,ThumCellDelagate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
    NSMutableDictionary *dict;
}

@property (nonatomic) int nCurrent;
@property (nonatomic,strong) NSMutableArray *aryLive;
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
    _dictIcon = [NSMutableDictionary dictionary];
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
    [_tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(requestTextLive)];
    [_tableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(requestMoreTextLive)];
}

- (void)requestMoreTextLive
{
    [_tableView.footer beginRefreshing];
    [_textSocket reqTextRoomList:_nCurrent count:20 type:1];
     _nCurrent += 20;
}

- (void)requestTextLive
{
    [_aryLive removeAllObjects];
    [_tableView reloadData];
    [_tableView.header beginRefreshing];
    [_tableView.footer resetNoMoreData];
    _nCurrent = 0;
    [_textSocket reqTextRoomList:_nCurrent count:20 type:1];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    if([cellCache objectForKey:cacheKey])
    {
        return [[cellCache objectForKey:cacheKey] floatValue]+80;
    }
    return 0;
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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateStyle = kCFDateFormatterShortStyle;
    fmt.timeStyle = kCFDateFormatterShortStyle;
    NSString *strTime = [fmt stringFromDate:date];
    
    [cell.lblTime setText:strTime];
    cell.section = indexPath.section;
    
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

- (void)liveCore:(LiveCoreTextCell *)liveCore msgid:(int64_t)messageid
{
    if (liveCore.btnThum.selected)
    {
        return ;
    }
    [_textSocket reqZans:messageid];
    liveCore.btnThum.selected = YES;
    [dict setObject:liveCore forKey:NSStringFromInt((int)messageid)];
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
          
         }];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showImageInfo:)]];
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        DTLazyImageView *imageView = [[DTLazyImageView alloc] initWithFrame:frame];
        NSString *strName = [attachment.attributes objectForKey:@"value"];
        if([strName intValue]==999 || [strName intValue]<=34)
        {
            [self findImage:strName imgView:imageView];
        }
        else
        {
            [self findImage:@"8" imgView:imageView];
        }
        return imageView;
    }
    return nil;
}

- (void)findImage:(NSString *)strName imgView:(UIImageView *)imageView
{
    UIImage *image = [_dictIcon objectForKey:strName];
    if (image)
    {
        [imageView setImage:image];
    }
    else
    {
        image = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:strName withExtension:@"gif"]];
        [_dictIcon setObject:image forKey:strName];
        [imageView setImage:image];
    }
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
