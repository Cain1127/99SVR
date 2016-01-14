//
//  TextLiveViewController.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveViewController.h"
#import "LiveCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+animatedGIF.h"

@interface TextLiveViewController ()<UITableViewDataSource,UITableViewDelegate,DTAttributedTextContentViewDelegate>
{
    NSCache *cellCache;
    NSMutableDictionary *_dictIcon;
}
@property (nonatomic,strong) NSMutableArray *aryLive;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation TextLiveViewController

- (void)initData
{
    for (int i=0; i<10; i++)
    {
        NSString *strContent = @"<div><img width=\"160\" height=\"160\" src=\"http://broadimage.99ducaijing.cn:8081/png/14522174930.png\"><span><h3>【股市藏经阁】下周一1.11震撼开播</h3>股市藏金窥利，凭技闯A股。2016年迎来熔断时代，行情大起大落猝不及防。提前休市背后因素何在？特约财经栏目《股市藏经阁》牵手向后市，【财神女王】艾菲坐镇主掌，特邀名威市场的【资深大师 】相约99°c财经！共探熔断玄机，解惑市场，挖掘接下来的操作应对策略！ 一堂不该错过的黄金命脉解剖课！（下周一01.11,3点半至5点整开播）</span></div>";
        [_aryLive addObject:strContent];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blueColor]];
    _aryLive = [NSMutableArray array];
    _dictIcon = [NSMutableDictionary dictionary];
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
    LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveCoreTextCell *cell = [self tableView:tableView preparedCellForIndexPath:indexPath];
    CGFloat fHeight = [cell.textCoreView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    return fHeight+66;
}

- (LiveCoreTextCell *)tableView:(UITableView *)tableView preparedCellForIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    strInfo = [_aryLive objectAtIndex:indexPath.section];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

@end
