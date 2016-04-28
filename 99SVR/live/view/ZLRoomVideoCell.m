//
//  ZLRoomVideoCell.m
//  99SVR
//
//  Created by xia zhonglin  on 4/28/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLRoomVideoCell.h"
#import "XVideoTeamInfo.h"
#import "ZLRoomVideoView.h"

#define kStartTag 1000

@interface ZLRoomVideoCell()
{
    NSArray *_rowDatas;
}

@end

@implementation ZLRoomVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat leftSpace = 8;
        CGFloat rightSpace = 5;
        for (int i=0; i<2; i++)
        {
            CGFloat viewWidth = kScreenWidth / 2 - leftSpace - rightSpace;
            CGFloat viewHeight = ((kScreenWidth-36)/2)*10/16+8;
            CGFloat viewX = 0;
            if (i == 0)
            {
                viewX = leftSpace;
            }
            else
            {
                viewX = kScreenWidth / 2 + rightSpace;
            }
            CGFloat viewY = 0;
            ZLRoomVideoView *cellView = [[ZLRoomVideoView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
            cellView.tag = i + kStartTag;
            [self.contentView addSubview:cellView];
        }
    }
    return self;
}

- (void)setRowDatas:(NSArray *)datas
{
    _rowDatas = datas;
    for (int i=0; i<2; i++)
    {
        ZLRoomVideoView *cellView = (ZLRoomVideoView *)[self.contentView viewWithTag:i + kStartTag];
        if (i > datas.count - 1)
        {
            cellView.hidden = YES;
        }
        else
        {
            cellView.hidden = NO;
            if(!datas && datas.count<i)
            {
                break;
            }
            XVideoModel *room = datas[i];
            cellView.videoModel = room;
            @WeakObj(self)
            @WeakObj(room)
            [cellView clickWithBlock:^(UIGestureRecognizer *gesture)
             {
                 if (selfWeak.itemOnClick)
                 {
                     selfWeak.itemOnClick(roomWeak);
                 }
             }];
        }
    }
}

@end

