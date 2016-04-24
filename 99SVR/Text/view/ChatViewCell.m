//
//  ChatViewCell.m
//  99SVR
//
//  Created by xia zhonglin  on 2/19/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ChatViewCell.h"

@interface ChatViewCell ()

@end

@implementation ChatViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _content = [DTAttributedTextContentView new];
    
    [self.contentView addSubview:_content];
    
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _content.frame = self.contentView.bounds;
    _content.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
}

@end
