//
//  LeftViewCell.m
//  99SVR
//
//  Created by 邹宇彬 on 15/12/18.
//  Copyright © 2015年 xia zhonglin . All rights reserved.
//

#import "LeftViewCell.h"
#import "LeftCellModel.h"
#define kImageWidth 17
#define kImageHeight 17

@implementation LeftBtn

- (instancetype)init
{
    if (self = [super init])
    {
        self.titleLabel.font = kFontSize(14);
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(15 + kImageWidth + 10,  (contentRect.size.height - kImageHeight) / 2, 100, kImageHeight);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(15, (contentRect.size.height - kImageHeight) / 2 , kImageWidth, kImageHeight);
}

@end

@interface LeftViewCell()
{
    UIImageView *_imgView;
    UILabel *_lblTitle;
}

@end

@implementation LeftViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _imgView = [[UIImageView alloc] initWithFrame:Rect(15,22-kImageWidth/2, kImageWidth, kImageWidth)];
        _lblTitle = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+10,_imgView.y, kScreenWidth, 16)];
        [_lblTitle setFont:XCFONT(14)];
        [_lblTitle setTextColor:UIColorFromRGB(0x343434)];
        
        _headLine = [[UILabel alloc] initWithFrame:Rect(0, 0, kScreenWidth, 0.5)];
        [_headLine setBackgroundColor:COLOR_Line_Small_Gay];
        
        _endLine = [[UILabel alloc] initWithFrame:Rect(0, 43.5, kScreenWidth, 0.5)];
        [_endLine setBackgroundColor:COLOR_Line_Small_Gay];
        
        [self.contentView addSubview:_lblTitle];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setModel:(LeftCellModel *)cellModel
{
    [_imgView setImage:[UIImage imageNamed:cellModel.icon]];
    [_lblTitle setText:cellModel.title];
    if (!_lblRight.hidden)
    {
        _lblRight.hidden = YES;
    }
}

- (void)setrightInfo:(NSString *)strInfo
{
    if (!_lblRight)
    {
        _lblRight = [[UILabel alloc] initWithFrame:Rect(kScreenWidth-100, _imgView.y, 92, 16)];
        [self.contentView addSubview:_lblRight];
        [_lblRight setFont:XCFONT(14)];
        [_lblRight setTextColor:UIColorFromRGB(0x343434)];
        [_lblRight setTextAlignment:NSTextAlignmentRight];
    }
    _lblRight.hidden = NO;
    [_lblRight setText:strInfo];
}

- (void)setHeadLineFrame:(CGRect )frame
{
    [_headLine setFrame:frame];
    [self.contentView addSubview:_headLine];
}

- (void)setEndLineFrame:(CGRect) frame
{
    [_endLine setFrame:frame];
    [self.contentView addSubview:_endLine];
}


@end
