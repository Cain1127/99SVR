//
//  ZLCoreTextCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/6/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ZLCoreTextCell.h"
#import <DTCoreText/DTCoreText.h>

@implementation ZLCoreTextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _attributedTextContextView = [DTAttributedTextContentView new];
    
    [self.contentView addSubview:_attributedTextContextView];
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_attributedTextContextView setFrame:self.contentView.bounds];
}

@end
