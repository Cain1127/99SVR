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
        [self setBackgroundColor:kLeftViewBgColor];
        UIView *bgView = [[UIView alloc] init];
        [bgView setBackgroundColor:RGB(47, 102, 172)];
        
        [self setSelectedBackgroundView:bgView];
        
        _imgView = [[UIImageView alloc] initWithFrame:Rect(15,22-kImageWidth/2, kImageWidth, kImageWidth)];
        _lblTitle = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+10,_imgView.y, 160, 16)];
        
        [_lblTitle setFont:XCFONT(14)];
        [_lblTitle setTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:_lblTitle];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setModel:(LeftCellModel *)cellModel
{
    [_imgView setImage:[UIImage imageNamed:cellModel.icon]];
    [_lblTitle setText:cellModel.title];
}

@end
