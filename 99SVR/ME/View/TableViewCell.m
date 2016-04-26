//
//  TableViewCell.m
//  Demo
//
//  Created by 林柏参 on 16/4/22.
//  Copyright © 2016年 XMG. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
        
    self.selectView.layer.borderColor = COLOR_STOCK_Line_Kuang.CGColor;
    self.selectView.layer.borderWidth = 0.5f;
    
    
    
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (IBAction)clickAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(tableViewCellWithClickButton:row:)]) {
        [self.delegate tableViewCellWithClickButton:sender row:_row];
    }
}

@end
