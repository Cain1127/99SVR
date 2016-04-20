//
//  RoomChatDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomChatDataSource.h"
#import <DTCoreText/DTCoreText.h>
#import "Photo.h"
#import "PhotoViewController.h"

@interface RoomChatDataSource()<DTAttributedTextContentViewDelegate>
{
    NSCache *chatCache;
}

@property (nonatomic,copy) NSArray *aryChat;

@end

@implementation RoomChatDataSource

- (id)init{
    self = [super init];
    chatCache = [[NSCache alloc] init];
    return self;
}

- (void)setModel:(NSArray *)aryChat
{
    _aryChat = aryChat;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _aryChat.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return cell;
}

- (DTAttributedTextCell *)tableView:(UITableView *)tableView chatPreparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NSString *key=nil;
    char cBuffer[100];
    sprintf(cBuffer,"chatView%zi-%zi",indexPath.section,indexPath.row);
    DTAttributedTextCell *cell = [chatCache objectForKey:key];
    if (!cell)
    {
        cell = [[DTAttributedTextCell alloc] initWithReuseIdentifier:cellIdentifier];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        cell.selectedBackgroundView = selectView;
        [chatCache setObject:cell forKey:key];
    }
    
    if(_aryChat.count>indexPath.row)
    {
        [self configureCell:cell forIndexPath:indexPath array:_aryChat];
    }
    [cell.attributedTextContextView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    return cell;
}

- (void)configureCell:(DTAttributedTextCell *)cell forIndexPath:(NSIndexPath *)indexPath array:(NSArray *)aryInfo
{
    NSString *html = [aryInfo objectAtIndex:indexPath.row];
    [cell setHTMLString:html];
    cell.attributedTextContextView.shouldDrawImages = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DTAttributedTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return [cell requiredRowHeightInTableView:tableView];
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
    button.minimumHitSize = CGSizeMake(25, 25); // adjusts it's bounds so that button is always large enough
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

@end
