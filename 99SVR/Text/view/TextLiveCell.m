//
//  TextLiveCell.m
//  99SVR
//
//  Created by xia zhonglin  on 1/9/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextLiveCell.h"

@interface TextLiveCell()
{
    
}

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *lblContent;
@property (nonatomic,strong) UILabel *lblName;


@end

@implementation TextLiveCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
