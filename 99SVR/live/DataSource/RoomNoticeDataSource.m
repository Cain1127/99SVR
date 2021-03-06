//
//  RoomNoticeDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomNoticeDataSource.h"
#import <DTCoreText/DTCoreText.h>
#import "ReplyNullInfoCell.h"
#import "NoticeModel.h"
#import "ZLCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "RoomChatNull.h"
#import <objc/runtime.h>

static char kShowBigImageUrlKey;// 公告大图URL

@interface RoomNoticeDataSource()<DTAttributedTextContentViewDelegate>
{
    NSCache *chatCache;
}

@property (nonatomic,copy) NSArray *aryNotice;

@end

@implementation RoomNoticeDataSource

- (id)init{
    self = [super init];
    chatCache = [[NSCache alloc] init];
    [chatCache setTotalCostLimit:10];
    return self;
}

- (void)setModel:(NSArray *)aryChat
{
    _aryNotice = aryChat;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_aryNotice.count==0) {
        return 1;
    }
    return _aryNotice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_aryNotice.count==0) {
        RoomChatNull *cell = [tableView dequeueReusableCellWithIdentifier:@"nullInfoCell"];
        if (!cell)
        {
            cell = [[RoomChatNull alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"nullInfoCell"];
        }
        cell.lblInfo.text = @"讲师没有发布公告";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    ZLCoreTextCell *cell = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = nil;
    NSString *strInfo = nil;
    ZLCoreTextCell *cell;
    cacheKey =[NSString stringWithFormat:@"LiveText-%zi", indexPath.section];
    if (_aryNotice.count>indexPath.section) {
        NoticeModel *textModel = [_aryNotice objectAtIndex:indexPath.section];
        strInfo = textModel.strContent;
        cell = [chatCache objectForKey:cacheKey];
        if (cell==nil)
        {
            cell = [[ZLCoreTextCell alloc] initWithReuseIdentifier:@"TextLiveIdentifier"];
            UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
            [selectView setBackgroundColor:[UIColor clearColor]];
            cell.selectedBackgroundView = selectView;
            [chatCache setObject:cell forKey:cacheKey];
        }
        if(![strInfo isEqualToString:cell.strInfo])
        {
            cell.attributedString = [[NSAttributedString alloc] initWithHTMLData:[strInfo dataUsingEncoding:NSUTF8StringEncoding]
                                                              documentAttributes:nil];
            cell.section = indexPath.section;
            cell.strInfo = strInfo;
            cell.textDelegate = self;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TextLiveIdentifier"];
        if (cell==nil)
        {
            cell = [[ZLCoreTextCell alloc] initWithReuseIdentifier:@"TextLiveIdentifier"];
        }
    }
    cell.layer.borderColor = COLOR_Line_Small_Gay.CGColor;
    cell.layer.borderWidth = 0.5;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_aryNotice.count==0)
    {
        return kScreenHeight-kRoom_head_view_height-kVideoImageHeight-44;
    }
    ZLCoreTextCell *coreText = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
    CGFloat height = [coreText.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenHeight, 10)];
    lineView.backgroundColor = COLOR_Bg_Gay;
    return lineView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}

#pragma mark DTCoreText Delegate

- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        @WeakObj(self)
        [imageView sd_setImageWithURL:attachment.contentURL
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             ZLCoreTextCell *cell = (ZLCoreTextCell*)attributedTextContentView.superview.superview;
             [selfWeak updateTextView:cell url:imageURL changeSize:image.size];
         }];
        imageView.userInteractionEnabled = YES;
        
        // 高清图URL
        NSString *strBigUrl =[attachment.attributes objectForKey:@"data-bigurl"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageInfo:)];
        [imageView addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &kShowBigImageUrlKey, strBigUrl, OBJC_ASSOCIATION_COPY);
        
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

- (void)updateTextView:(ZLCoreTextCell*)text url:(NSURL*)url changeSize:(CGSize)size
{
    CGSize imageSize ;
    if (size.width>kScreenWidth) {
        imageSize.width = (kScreenWidth-20);
        CGFloat width = imageSize.width;
        imageSize.height = size.height/(size.width/width);
    }
    else
    {
        imageSize = size;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contentURL == %@", url];
    BOOL didUpdate = NO;
    for (DTTextAttachment *oneAttachment in [text.attributedTextContextView.layoutFrame textAttachmentsWithPredicate:pred])
    {
        if (CGSizeEqualToSize(oneAttachment.originalSize, CGSizeZero))
        {
            oneAttachment.originalSize = imageSize;
            didUpdate = YES;
        }
    }
    if (didUpdate)
    {
        if ([text.superview.superview isKindOfClass:[UITableView class]]) {
            [text relayoutText];
            UITableView *tableView = (UITableView *)text.superview.superview;
            [tableView reloadData];
        }
        [text setNeedsLayout];
    }
}

#pragma mark Custom Views on Text
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttributedString:(NSAttributedString *)string frame:(CGRect)frame
{
    //超链接操作
    NSDictionary *attributes = [string attributesAtIndex:0 effectiveRange:NULL];
    NSURL *URL = [attributes objectForKey:DTLinkAttribute];
    NSString *identifier = [attributes objectForKey:DTGUIDAttribute];
    DTLinkButton *button = [[DTLinkButton alloc] initWithFrame:frame];
    button.URL = URL;
    button.minimumHitSize = CGSizeMake(25, 25);
    button.GUID = identifier;
    [button addTarget:self action:@selector(linkPushed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark 点击超链接
- (void)linkPushed:(DTLinkButton *)sender
{
    DLog(@"路径:%@",sender.URL.absoluteString);
    if([sender.URL.absoluteString rangeOfString:@"sqchatid://"].location != NSNotFound)
    {
        
    }
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    NSString *strBigUrl = objc_getAssociatedObject(self, &kShowBigImageUrlKey);
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:strBigUrl] placeholderImage:imageView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSMutableArray *aryIndex = [NSMutableArray array];
        Photo *_photo = [[Photo alloc] init];
        _photo.nId = 0;
        _photo.imgName = image?:imageView.image;
        [aryIndex addObject:_photo];
        PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
        [photoControl show];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

