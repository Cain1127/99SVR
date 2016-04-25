//
//  TextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 3/31/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextCell.h"
#import "TextCellView.h"

#define kStartTag 1000

@interface TextCell()
{
    NSArray *_rowDatas;
}

@end

@implementation TextCell

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
            TextCellView *cellView = [[TextCellView alloc] initWithFrame:CGRectMake(viewX, viewY, viewWidth, viewHeight)];
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
        TextCellView *cellView = (TextCellView *)[self.contentView viewWithTag:i + kStartTag];
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
            TextRoomModel *room = datas[i];
            cellView.room = room;
            @WeakObj(room)
            @WeakObj(self)
            [cellView addGesture:^(id sender)
             {
                 if (selfWeak.itemOnClick)
                 {
                     selfWeak.itemOnClick(roomWeak);
                 }
             }];
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
