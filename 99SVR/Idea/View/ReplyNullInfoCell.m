//
//  ReplyNullInfoCell.m
//  99SVR
//
//  Created by xia zhonglin  on 4/27/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "ReplyNullInfoCell.h"
#import "ViewNullFactory.h"
@implementation ReplyNullInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    char cString[255];
    const char *path = [[[NSBundle mainBundle] bundlePath] UTF8String];
    sprintf(cString, "%s/text_viewpoint_not_omment.png",path);
    NSString *objCString = [[NSString alloc] initWithUTF8String:cString];
    UIImage *image = [UIImage imageWithContentsOfFile:objCString];
    if (image)
    {
        _view = [ViewNullFactory createViewBg:Rect(0, 0, kScreenWidth, 200) imgView:image msg:@"来抢个沙发吧!"];
        [self.contentView addSubview:_view];
    }
    
    return self;
}

- (void)awakeFromNib {
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
