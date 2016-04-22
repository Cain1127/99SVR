

#define lab_Top ValueWithTheIPhoneModelString(@"20,20,20,20") //第一个labe距离上面的高度
#define lab_Bottom ValueWithTheIPhoneModelString(@"20,20,20,20") //最后一个label距离下面的高度
#define lab_h ValueWithTheIPhoneModelString(@"15,15,15,15") //所有lab的高度


#import "StockDealCellView.h"
#import "StockMacro.h"
@implementation StockDealCellView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    //标题
    self.titleLabV = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,lab_Top,ScreenWidth,lab_h}];
    [self addSubview:self.titleLabV];
    
    //间隔
    CGFloat jiangeFloat = (self.height-(3*lab_h)-lab_Top-lab_Bottom)/2.0;
    
    //成本
    self.costRmbLabV = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(self.titleLabV.frame)+jiangeFloat,ScreenWidth,lab_h}];
    [self addSubview:self.costRmbLabV];
    
    //现价
    self.nowRmbLabV = [[StockDealCellLabelView alloc]initWithFrame:(CGRect){0,CGRectGetMaxY(self.costRmbLabV.frame)+jiangeFloat,ScreenWidth,lab_h}];
    [self addSubview:self.nowRmbLabV];

}

@end
