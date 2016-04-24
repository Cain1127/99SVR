//
//  RoomCoreTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 2/26/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "RoomCoreTextCell.h"

@implementation RoomCoreTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _textView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:_textView];
    [self.contentView setBackgroundColor:UIColorFromRGB(0xF8F8F8)];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_textView setFrame:Rect(0,0, kScreenWidth, self.contentView.height)];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
