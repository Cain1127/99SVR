//
//  RoomNoticeDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomNoticeDataSource.h"
#import <DTCoreText/DTCoreText.h>
#import "NoticeModel.h"
#import "ZLCoreTextCell.h"
#import "Photo.h"
#import "PhotoViewController.h"

@interface RoomNoticeDataSource()
{
    NSCache *chatCache;
}

@property (nonatomic,copy) NSArray *aryNotice;

@end

@implementation RoomNoticeDataSource

- (id)init{
    self = [super init];
    chatCache = [[NSCache alloc] init];
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
    return _aryNotice.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZLCoreTextCell *cell = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (ZLCoreTextCell *)tableView:(UITableView *)tableView preparedCellForZLIndexPath:(NSIndexPath *)indexPath
{
    NSString *cacheKey = [NSString stringWithFormat:@"%zi-%zi",indexPath.row,indexPath.section];
    NSString *strInfo;
    ZLCoreTextCell *cell = nil;
    NSString *strIdentifier = @"kNoticeIdentifier";
    cell = [chatCache objectForKey:cacheKey];
    if (cell==nil)
    {
        cell = [[ZLCoreTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
        [chatCache setObject:cell forKey:cacheKey];
    }
    if(_aryNotice.count > indexPath.section)
    {
        char cString[150] = {0};
        sprintf(cString,"noticeView-%zi",indexPath.section);
        cacheKey = [[NSString alloc] initWithUTF8String:cString];
        NoticeModel *notice = [_aryNotice objectAtIndex:indexPath.section];
        strInfo = notice.strContent;
        strIdentifier = @"kNoticeIdentifier";
    }
    else
    {
        return cell;
    }
    cell.lblInfo.attributedTextContentView.shouldDrawImages = YES;
    cell.lblInfo.attributedTextContentView.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    NSData *data = [strInfo dataUsingEncoding:NSUTF8StringEncoding];
    cell.lblInfo.attributedString = [[NSAttributedString alloc] initWithHTMLData:data options:nil documentAttributes:nil];
    UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
    [selectView setBackgroundColor:[UIColor clearColor]];
    cell.selectedBackgroundView = selectView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZLCoreTextCell *coreText = [self tableView:tableView preparedCellForZLIndexPath:indexPath];
    return [coreText.lblInfo.attributedTextContentView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-20].height;
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView sd_setImageWithURL:attachment.contentURL];
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
        //        NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
        //        toUser = [strNumber intValue];
        //        if (_tcpSocket.getRoomInfo != nil)
        //        {
        //            RoomUser *rUser = [_tcpSocket.getRoomInfo findUser:toUser];
        //            [_inputView setChatInfo:rUser];
        //        }
    }
}

- (void)showImageInfo:(UITapGestureRecognizer *)tapGest
{
    UIImageView *imageView = (UIImageView *)tapGest.view;
    if (imageView.image)
    {
        NSMutableArray *aryIndex = [NSMutableArray array];
        Photo *_photo = [[Photo alloc] init];
        _photo.nId = 0;
        _photo.imgName = imageView.image;
        [aryIndex addObject:_photo];
        PhotoViewController *photoControl = [[PhotoViewController alloc] initWithArray:aryIndex current:0];
        [photoControl show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end

