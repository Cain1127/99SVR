//
//  TeachView.m
//  99SVR
//
//  Created by xia zhonglin  on 3/2/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TeachView.h"
#import "TeacherModel.h"
#import "UIImageView+WebCache.h"

@implementation TeachView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:UIColorFromRGB(0x427ede)];
    _imgHead = [[UIImageView alloc] initWithFrame:Rect(15, 12, 65, 65)];
    [self addSubview:_imgHead];
    
    UIColor *color = UIColorFromRGB(0xB2CDFF);
    UIColor *linecolor = UIColorFromRGB(0x6898e5);
    
    UILabel *lblTempFans = [[UILabel alloc] initWithFrame:Rect(_imgHead.x+_imgHead.width+15, 44,70, 20)];
    [lblTempFans setText:@"粉丝"];
    [lblTempFans setTextColor:color];
    [lblTempFans setFont:XCFONT(15)];
    [self addSubview:lblTempFans];
    
    _lblFans = [[UILabel alloc] initWithFrame:Rect(lblTempFans.x, lblTempFans.y+lblTempFans.height+10,lblTempFans.width,20)];
    [_lblFans setFont:XCFONT(15)];
    [_lblFans setTextColor:color];
    [self addSubview:_lblFans];
    
    UILabel *line1 = [[UILabel alloc] initWithFrame:Rect(lblTempFans.x+lblTempFans.width+2, lblTempFans.y, 0.5, 40)];
    [self addSubview:line1];
    [line1 setBackgroundColor:linecolor];
    
    UILabel *lblTempThum = [[UILabel alloc] initWithFrame:Rect(line1.x+3, 44,70, 20)];
    [lblTempThum setText:@"赞"];
    [lblTempThum setTextColor:color];
    [lblTempThum setFont:XCFONT(15)];
    [lblTempThum setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lblTempThum];
    
    _lblThum = [[UILabel alloc] initWithFrame:Rect(lblTempThum.x, lblTempThum.y+lblTempThum.height+10,lblTempThum.width,20)];
    [_lblThum setFont:XCFONT(15)];
    [_lblThum setTextColor:color];
    [_lblThum setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_lblThum];
    
    UILabel *line2 = [[UILabel alloc] initWithFrame:Rect(lblTempThum.x+lblTempThum.width+2, lblTempThum.y, 0.5, 40)];
    [self addSubview:line2];
    [line2 setBackgroundColor:linecolor];
    
    UILabel *lblTempCount = [[UILabel alloc] initWithFrame:Rect(line2.x+3, 44,70, 20)];
    [lblTempCount setText:@"人气"];
    [lblTempCount setTextColor:color];
    [lblTempCount setFont:XCFONT(15)];
    [lblTempCount setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lblTempCount];
    
    _lblCount = [[UILabel alloc] initWithFrame:Rect(lblTempCount.x, lblTempCount.y+lblTempCount.height+10,lblTempCount.width,20)];
    [_lblCount setFont:XCFONT(15)];
    [_lblCount setTextColor:color];
    [_lblCount setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_lblCount];
    
    self.layer.shadowColor = UIColorFromRGB(0x1b3c6d).CGColor;
    self.layer.shadowOffset = CGSizeMake(0,0);
    self.layer.shadowOpacity = 0.8;
    self.layer.shadowRadius = 4;
    
    UILabel *lblLine = [[UILabel alloc] initWithFrame:Rect(15, _lblCount.y+_lblCount.height+12, kScreenWidth-30, 0.5)];
    [lblLine setBackgroundColor:color];
    [self addSubview:lblLine];
    
    _lblContent= [[UILabel alloc] initWithFrame:Rect(15, lblLine.y+8,kScreenWidth-30,50)];
    [self addSubview:_lblContent];
    [_lblContent setTextColor:UIColorFromRGB(0xffffff)];
    _lblContent.font = XCFONT(12);
    _lblContent.numberOfLines=0;
    
    return self;
}


- (void)setTeachModel:(TeacherModel *)model
{
    NSString *url = [NSString stringWithFormat:@"%@%d",kImage_TEXT_URL,model.teacherid];
    [_imgHead sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"logo"]];
    _lblFans.text = NSStringFromInt64(model.fans);
    _lblThum.text = NSStringFromInt64(model.zans);
    _lblCount.text = NSStringFromInt64(model.zans);
    
    [_lblContent setText:model.strContent];
    CGRect rect = [model.strContent boundingRectWithSize:CGSizeMake(kScreenWidth-30,100)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:XCFONT(12)}
                                              context:nil];
//    CGSize size = [model.strContent sizeWithAttributes:@{NSFontAttributeName:XCFONT(12)}];
    CGRect frame = _lblContent.frame;
    _lblContent.frame = Rect(frame.origin.x, frame.origin.y,kScreenWidth-30,rect.size.height);
    self.frame = Rect(0, 64, kScreenWidth, _lblContent.y+_lblContent.height+8);
}

@end
