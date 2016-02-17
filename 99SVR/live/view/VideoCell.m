//
//  VedioCell.m
//  StrechableTableView
//
//  Created by 邹宇彬 on 15/12/16.
//  Copyright © 2015年 邹宇彬. All rights reserved.
//

#import "VideoCell.h"
#import "VideoCellView.h"
#import "RoomHttp.h"
//#import "Vedio.h"

#define kStartTag 1000

@interface VideoCell()
{
    NSArray *_rowDatas;
}

@end

@implementation VideoCell

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
            //CGFloat viewHeight = ((kScreenWidth-36)/2)*5/9+8;
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
            VideoCellView *cellView = [[VideoCellView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
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
        VideoCellView *cellView = (VideoCellView *)[self.contentView viewWithTag:i + kStartTag];
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
            RoomHttp *room = datas[i];
            cellView.room = room;
            __weak RoomHttp *__room = room;
            __weak VideoCell *__self = self;
            
            [cellView addGesture:^(id sender)
            {
                if (_itemOnClick)
                {
                    __self.itemOnClick(__room);
                }
            }];
            [cellView clickWithBlock:^(UIGestureRecognizer *gesture)
            {
                if (_itemOnClick)
                {
                    __self.itemOnClick(__room);
                }
            }];
        }
    }
}

@end
