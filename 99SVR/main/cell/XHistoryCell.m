//
//  XHistoryCell.m
//  99SVR
//
//  Created by xia zhonglin  on 4/20/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "XHistoryCell.h"
#import "CustomViewController.h"

@implementation XHistoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    _lblText = [[UILabel alloc] initWithFrame:Rect(10, 10, 200, 24)];
    [_lblText setFont:XCFONT(14)];
    [self.contentView addSubview:_lblText];
    
    _btnDel = [CustomViewController itemWithTarget:self action:@selector(clickEvent) image:@"delHistory" highImage:@"delHistory"];
    _btnDel.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_btnDel];
    [_btnDel setFrame:Rect(kScreenWidth-50, 0, 44, 44)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:Rect(0, 43.5, kScreenWidth, 0.5)];
    [self.contentView addSubview:line];
    [line setBackgroundColor:COLOR_Line_Small_Gay];
    
    return self;
}

- (void)clickEvent{
    if ([_lblText.text length]>0 && _delegate && [_delegate respondsToSelector:@selector(delText:)]) {
        [_delegate delText:_lblText.text];
    }
}

@end
