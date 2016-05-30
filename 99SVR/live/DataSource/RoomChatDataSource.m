//
//  RoomChatDataSource.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomChatDataSource.h"
#import <DTCoreText/DTCoreText.h>
#import "RoomChatNull.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "ChatCoreTextCell.h"

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
    [chatCache setTotalCostLimit:10];
    return self;
}

- (void)setModel:(NSArray *)aryChat
{
    _aryChat = aryChat;
}

- (void)setRowLength:(NSInteger)nLength
{
    _nLength = nLength;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"_nLength:%zi",_nLength);
    return _nLength;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatCoreTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return cell;
}

- (ChatCoreTextCell *)tableView:(UITableView *)tableView chatPreparedCellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    NSString *key=nil;
    char cBuffer[100];
    sprintf(cBuffer,"chatView%zi-%zi",indexPath.section,indexPath.row);
    ChatCoreTextCell *cell = [chatCache objectForKey:key];
    if (!cell)
    {
        cell = [[ChatCoreTextCell alloc] initWithReuseIdentifier:cellIdentifier];
        UIView *selectView = [[UIView alloc] initWithFrame:cell.bounds];
        [selectView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
        cell.selectedBackgroundView = selectView;
        cell.backgroundColor = UIColorFromRGB(0xf8f8f8);
        [chatCache setObject:cell forKey:key];
        cell.attributedTextContextView.edgeInsets = UIEdgeInsetsMake(10, 10, 0, 64);
    }
    if(_aryChat.count>indexPath.row)
    {
        [self configureCell:cell forIndexPath:indexPath array:_aryChat];
    }
    [cell.attributedTextContextView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    cell.textDelegate = self;
    return cell;
}

- (void)configureCell:(ChatCoreTextCell *)cell forIndexPath:(NSIndexPath *)indexPath array:(NSArray *)aryInfo
{
    NSString *html = [aryInfo objectAtIndex:indexPath.row];
    [cell setHTMLString:html options:@{DTDefaultTextColor:@"#343434"}];
    cell.attributedTextContextView.shouldDrawImages = YES;
    cell.fHeight = [cell.attributedTextContextView suggestedFrameSizeToFitEntireStringConstraintedToWidth:kScreenWidth-74].height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCoreTextCell *cell = [self tableView:tableView chatPreparedCellForIndexPath:indexPath];
    return cell.fHeight;
}

#pragma mark DTCoreText Delegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTImageTextAttachment class]])
    {
        frame.origin.y += 10;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        if([attachment.contentURL.absoluteString rangeOfString:@"vip_header_"].location ==0)
        {
            [imageView setImage:[UIImage imageNamed:attachment.contentURL.absoluteString]];
        }
        else
        {
            [imageView sd_setImageWithURL:attachment.contentURL];
        }
        imageView.userInteractionEnabled = YES;
        return imageView;
    }
    else if([attachment isKindOfClass:[DTObjectTextAttachment class]])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:Rect(frame.origin.x,(20-frame.size.height)/2, frame.size.width, frame.size.height)];
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
        NSString *strNumber = [sender.URL.absoluteString stringByReplacingOccurrencesOfString:@"sqchatid://" withString:@""];
        int toUser = [strNumber intValue];
        if (_delegate && [_delegate respondsToSelector:@selector(showKeyboard:)]) {
            [_delegate showKeyboard:toUser];
        }
    }
}


@end
