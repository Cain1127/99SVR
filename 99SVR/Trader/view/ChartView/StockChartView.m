

#define leftLab_w   ValueWithTheIPhoneModelString(@"50,50,50,50") //左侧标题的宽度
#define leftLab_h ValueWithTheIPhoneModelString(@"17,17,17,17") //左侧标题的高度
#define topMenu_h ValueWithTheIPhoneModelString(@"50,50,50,50") //顶部控制栏的高度
#define topMenuBtn_h (topMenu_h/2.0-3) //顶部控制栏按钮的高度
#define topMenuBtn_w ValueWithTheIPhoneModelString(@"50,50,50,50") //顶部按钮的宽度
#define lowMenu_h ValueWithTheIPhoneModelString(@"50,50,50,50") //底部按钮的高度
#define lowLab_w   ValueWithTheIPhoneModelString(@"60,60,60,60") //底部标题的宽度
#define lowLab_h ValueWithTheIPhoneModelString(@"17,17,17,17") //底部标题的高度
#import "StockChartView.h"
#import "MacroHeader.h"
@interface StockChartView ()
{
    CGFloat _width;
    CGFloat _height;
}
/**顶部控制器*/
@property (nonatomic, strong) UIView *topMenuView;
/**底部Uive*/
@property (nonatomic , strong) UIView *lowMenuView;
/**顶部控制器 lineView*/
@property (nonatomic , strong) UIView *topMenuLineView;
@end

@implementation StockChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        _width = frame.size.width;
        _height = frame.size.height;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.f];
        
        [self iniUI];
        
    }
    return self;
}

-(void)iniUI{
    
    
    //顶部控制View
    [self addSubview:self.topMenuView];
    //底部控制画图
    self.lineChartView = [[DDLineChartView alloc]initWithFrame:(CGRect){leftLab_w,topMenu_h+20,(_width-leftLab_w - 10),(_height-topMenu_h - lowMenu_h-20)}];
    
    NSMutableArray *array_y =[NSMutableArray array];
    NSMutableArray *array_y1 =[NSMutableArray array];
    
    for (int i=0; i!=10; i++) {
        [array_y addObject:[NSString stringWithFormat:@"%u",arc4random()%500+500]];
    }
    
    for (int i=0; i!=10; i++) {
        [array_y1 addObject:[NSString stringWithFormat:@"%u",arc4random()%500+500]];
    }
    
    self.lineChartView.valuePoints_Y = @[array_y,array_y1];//第一是组合 第二是HS300
    self.lineChartView.drawLine_X = YES;
    self.lineChartView.drawLine_Y = NO;
    self.lineChartView.lineColors = @[COLOR_STOCK_Line_ZuHe,COLOR_STOCK_Line_HS300];
    self.lineChartView.timeValue = 0.5;
    self.lineChartView.raneValue_Y = CGRangeMake(-2000, 2000);
    self.lineChartView.level_Y = 2;
    self.lineChartView.level_X = 2;
    [self addSubview:self.lineChartView];
    [self.lineChartView drawLine];

    //底部
    [self addSubview:self.lowMenuView];
    
}
#pragma mark 左边
-(void)setLeftTitArrays:(NSArray *)leftTitArrays{
    
    _leftTitArrays = leftTitArrays;
    for (int i=0; i!=leftTitArrays.count; i++) {
        CGFloat labelOriginY = CGRectGetMinY(self.lineChartView.frame) - leftLab_h/2.0 + i*(CGRectGetHeight(self.lineChartView.frame)/(leftTitArrays.count-1));
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){0,labelOriginY,leftLab_w,leftLab_h}];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR_STOCK_Text_Black;
        label.text = _leftTitArrays[i];
        label.font = [UIFont systemFontOfSize:13];
        [self addSubview:label];
    }
}
#pragma mark 底部label
-(void)setLowTitArrays:(NSArray *)lowTitArrays{

    _lowTitArrays = lowTitArrays;
    for (int i=0; i!=lowTitArrays.count; i++) {
        CGFloat labOriginX = CGRectGetMinX(self.lineChartView.frame) + i *(CGRectGetWidth(self.lineChartView.frame)-(lowLab_w * lowTitArrays.count))/(lowTitArrays.count-1) + i*lowLab_w;
        UILabel *label = [[UILabel alloc]initWithFrame:(CGRect){labOriginX,10,lowLab_w,lowLab_h}];
        label.textColor = COLOR_STOCK_Text_Black;
        label.text = lowTitArrays[i];
        label.font = [UIFont systemFontOfSize:13];
        
        if (i==0) {
            label.textAlignment = NSTextAlignmentLeft;
        }else if (i==lowTitArrays.count-1){
            
            label.textAlignment = NSTextAlignmentRight;
        }else{
            
            label.textAlignment = NSTextAlignmentCenter;
        }
        
        [_lowMenuView addSubview:label];
    }
    
    UIView *lowLineView = [[UIView alloc]initWithFrame:(CGRect){CGRectGetMinX(self.lineChartView.frame),CGRectGetMaxY(self.lineChartView.frame),CGRectGetWidth(self.lineChartView.frame),1}];
    [self addSubview:lowLineView];
    lowLineView.backgroundColor = COLOR_STOCK_Line_Kuang;
    
    for (int i=0; i!=lowTitArrays.count; i++) {
        
        CGFloat originX = i*(lowLineView.frame.size.width/(lowTitArrays.count-1));
        UIView *verticalView = [[UIView alloc]initWithFrame:(CGRect){originX,0,1,5}];
        verticalView.backgroundColor = lowLineView.backgroundColor;
        [lowLineView addSubview:verticalView];
    }
    
    
}
#pragma mark 顶部控制按钮
-(void)setTopTitItems:(NSArray *)topTitItems{
    _topTitItems = topTitItems;
    
    for (int i=0; i!=_topTitItems.count; i++) {
        
        NSString *itemName = _topTitItems[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = (CGRect){i*topMenuBtn_w + (i+1)*10,0,topMenuBtn_w,topMenuBtn_h};
//        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitle:itemName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        if (i==0) {
            btn.enabled = NO;
            self.topMenuLineView = [[UIView alloc]initWithFrame:(CGRect){CGRectGetMinX(btn.frame),topMenu_h/2.0-2,CGRectGetWidth(btn.frame),2}];
            self.topMenuLineView.backgroundColor = UIColorFromRGB(0x0078dd);
            [self.topMenuView addSubview:self.topMenuLineView];
        }
        btn.tag = i+1;
        [btn addTarget:self action:@selector(clickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_topMenuView addSubview:btn];
    }
}
#pragma mark 顶部
-(UIView *)topMenuView{
    
    if (!_topMenuView) {
     
        _topMenuView = [[UIView alloc]initWithFrame:(CGRect){0,0,_width,topMenu_h}];
        _topMenuView.userInteractionEnabled = YES;
        
        //中间的线
        UIView *minView = [[UIView alloc]initWithFrame:(CGRect){10,topMenu_h/2.0,_width-20,1}];
        minView.backgroundColor = COLOR_STOCK_Blue;
;
        [_topMenuView addSubview:minView];
        
        //最右边的标签
        //沪深Label
        UILabel *hsLabel = [[UILabel alloc]init];
        hsLabel.font = [UIFont systemFontOfSize:13];
        hsLabel.text = @"沪深300";
        hsLabel.textColor = COLOR_STOCK_Text_Black;
        [hsLabel sizeToFit];
        CGFloat hsLabOriginX = CGRectGetMaxX(minView.frame) - hsLabel.frame.size.width;
        CGFloat hsLabOriginY = topMenu_h/2.0 + (topMenu_h/2.0 - hsLabel.frame.size.height)/2.0;
        hsLabel.frame = (CGRect){hsLabOriginX,hsLabOriginY,hsLabel.frame.size.width,hsLabel.frame.size.height};
        [_topMenuView addSubview:hsLabel];
        
        //沪深三板蓝色的线
        UIView *hsLineView = [[UIView alloc]init];
        hsLineView.backgroundColor = COLOR_STOCK_Line_HS300;
        CGFloat hsLVOriginX = hsLabOriginX - 5 -10;
        hsLineView.frame = (CGRect){hsLVOriginX,hsLabel.center.y,10,1};
        [_topMenuView addSubview:hsLineView];
        
        //组合收益
        UILabel *zhLab = [[UILabel alloc]init];
        zhLab.font = [UIFont systemFontOfSize:13];
        zhLab.text = @"组合收益";
        zhLab.textColor = COLOR_STOCK_Text_Black;
        [zhLab sizeToFit];
        CGFloat zhLabeOriginX = hsLVOriginX -10 - zhLab.frame.size.width;
        zhLab.frame = (CGRect){zhLabeOriginX,CGRectGetMinY(hsLabel.frame),zhLab.frame.size.width,zhLab.frame.size.height};
        [_topMenuView addSubview:zhLab];
        
        //组合收益橙色的线
        UIView *zhLineView = [[UIView alloc]init];
        zhLineView.backgroundColor = COLOR_STOCK_Line_ZuHe;
        CGFloat zhLVOriginX = zhLabeOriginX - 5 -10;
        zhLineView.frame = (CGRect){zhLVOriginX,hsLabel.center.y,10,1};
        [_topMenuView addSubview:zhLineView];
        
    }
    return _topMenuView;
}
-(UIView *)lowMenuView{
    
    if (!_lowMenuView) {
        
        _lowMenuView = [[UIView alloc]initWithFrame:(CGRect){0,(CGRectGetMaxY(self.lineChartView.frame)),_width,lowMenu_h}];
    }
    
    return _lowMenuView;
}

#pragma mark 按钮点击事件
-(void)clickBtnAction:(UIButton *)btn{
    for (int i=0; i!=_topTitItems.count; i++) {
        UIButton *b = [self viewWithTag:i+1];
        b.enabled  = YES;
    }
    btn.enabled = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.topMenuLineView.frame =(CGRect){CGRectGetMinX(btn.frame),topMenu_h/2.0-2,CGRectGetWidth(btn.frame),2};
    }];


    
    NSMutableArray *array_y =[NSMutableArray array];
    NSMutableArray *array_y1 =[NSMutableArray array];

    for (int i=0; i!=10; i++) {
        [array_y addObject:[NSString stringWithFormat:@"%d",(int)arc4random()%500-500*(btn.tag)]];
    }
    
    for (int i=0; i!=10; i++) {
        [array_y1 addObject:[NSString stringWithFormat:@"%d",(int)arc4random()%500-500*(btn.tag)]];
    }
    [self.lineChartView clearLine];
    self.lineChartView.valuePoints_Y = @[array_y,array_y1];
    [self.lineChartView drawLine];

}



@end