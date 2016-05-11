//
//  XMeCustomCell.m
//  99SVR
//
//  Created by xia zhonglin  on 4/24/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XMeCustomCell.h"

@implementation XMeCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _imgView = [[UIImageView alloc] initWithFrame:Rect(8, 8, 64, 64)];
    [self.contentView addSubview:_imgView];
    _imgView.layer.masksToBounds = YES;
    _imgView.layer.cornerRadius = 32;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
    
    _lblName = [[UILabel alloc] initWithFrame:Rect(_imgView.x+_imgView.width+10, _imgView.y, 200, 20)];
    [_lblName setFont:XCFONT(15)];
    [_lblName setTextColor:COLOR_Text_Black];
    [self.contentView addSubview:_lblName];
    
    _imgLevel = [[UIImageView alloc] initWithFrame:Rect(_lblName.x, _lblName.y+_lblName.height, 25, 25)];
    [self.contentView addSubview:_imgLevel];
    
    _lblLevel = [[UILabel alloc] initWithFrame:Rect(_imgLevel.x+_imgLevel.width+5, _imgLevel.y + 3, 50, 20)];
    [_lblLevel setFont:XCFONT(15)];
    [_lblLevel setTextColor:COLOR_Text_Black];
    [self.contentView addSubview:_lblLevel];
    
    _lblTime = [[UILabel alloc] initWithFrame:Rect(_imgLevel.x, _imgLevel.y+_imgLevel.height+5, ScreenWidth - (CGRectGetMaxX(_imgView.frame)), 15)];
    [_lblTime setFont:XCFONT(15)];
    [_lblTime setTextColor:COLOR_Text_Black];
    [self.contentView addSubview:_lblTime];
    
    return self;
}

@end
