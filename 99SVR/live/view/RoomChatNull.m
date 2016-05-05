//
//  RoomChatNull.m
//  99SVR
//
//  Created by xia zhonglin  on 5/4/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomChatNull.h"

@implementation RoomChatNull

- (void)awakeFromNib
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self.contentView setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
    _imgView = [[UIImageView alloc] initWithFrame:Rect(0, 8, kScreenWidth, 130)];
    char cString[255];
    const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
    sprintf(cString, "%s/text_blank_page.png",path);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    UIImage *image = [UIImage imageWithContentsOfFile:objCString];
    [_imgView setImage:image];
    [self.contentView addSubview:_imgView];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    
    _lblInfo = [[UILabel alloc] initWithFrame:Rect(0, 143, kScreenWidth, 20)];
    [_lblInfo setFont:XCFONT(15)];
    [_lblInfo setTextColor:UIColorFromRGB(0x919191)];
    [_lblInfo setTextAlignment:NSTextAlignmentCenter];
    [self.contentView addSubview:_lblInfo];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imgView.frame = Rect(0, 0, kScreenWidth, self.contentView.height*0.8);
    _lblInfo.frame = Rect(0, _imgView.y+_imgView.height+8, kScreenWidth, 20);
}

@end
