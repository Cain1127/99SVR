//
//  TextNewViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//  观点类

#import "TextNewViewController.h"
#import <DTCoreText/DTCoreText.h>
#import "IdeaDetails.h"
#import "TextLiveModel.h"
#import "LiveCoreTextCell.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImage+animatedGIF.h"
#import "TextTcpSocket.h"

@interface TextNewViewController ()<UITableViewDelegate,UITableViewDataSource,DTAttributedTextContentViewDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,copy) NSArray *aryNew;


@end

@implementation TextNewViewController

- (void)initUIBody
{
    _tableView = [[UITableView alloc] initWithFrame:Rect(0, 0, kScreenWidth, kScreenHeight-108)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUIBody];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL completed:^(UIImage *image, NSError *error,
                                                                        SDImageCacheType cacheType, NSURL *imageURL)
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
        //[$3$]  [$999$] [$62$]
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _aryNew.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
    return cell;
}


- (LiveCoreTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    cacheKey =[NSString stringWithFormat:@"newtableview-%zi", indexPath.section];
    IdeaDetails *textModel = [_aryNew objectAtIndex:indexPath.section];
    strInfo = textModel.strContent;
    if (cellCache == nil )
    {
        cellCache = [[NSCache alloc] init];
    }
    LiveCoreTextCell *cell = [cellCache objectForKey:cacheKey];
    if (cell==nil)
    {
        cell = [[LiveCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextLiveIdentifier"];
    }
    cell.textCoreView.delegate = self;
    cell.textCoreView.shouldDrawImages = YES;
    [cellCache setObject:cell forKey:cacheKey];
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
    CGFloat fHeight = [cell.textCoreView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    return fHeight+66;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IdeaDetails *idea = [_aryNew objectAtIndex:indexPath.section];
    DLog(@"idea:%zi",idea.messageid);
//    [[TextTcpSocket sharedTextTcpSocket] reqIdeaDetails:0 count:20 ideaId:(int)idea.messageid];
//    [[TextTcpSocket sharedTextTcpSocket] replyCommentReq:@"你好啊" msgid:idea.messageid toid:idea.userid];
//    [[TextTcpSocket sharedTextTcpSocket] reqCommentZan:idea.messageid];
    [[TextTcpSocket sharedTextTcpSocket] reqSendFlower:idea.messageid count:20];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadNew) name:MESSAGE_TEXT_NEW_VC object:nil];
}

- (void)reloadNew
{
    _aryNew = [TextTcpSocket sharedTextTcpSocket].aryNew;
    __weak TextNewViewController *__self = self;
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [__self.tableView reloadData];
    });
}


@end
