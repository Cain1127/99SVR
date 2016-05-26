


#import "HDSegmentedView.h"
#define badgeView_W 15
#define timeValue 0.5

@interface HDSegmentedViewLabel ()
{
    UILabel *_badgeLabe;
}
@end

@implementation HDSegmentedViewLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _badgeLabe = [[UILabel alloc]initWithFrame:(CGRect){frame.size.width-badgeView_W-1,1,badgeView_W,badgeView_W}];
        _badgeLabe.textAlignment = NSTextAlignmentCenter;
        _badgeLabe.font = [UIFont systemFontOfSize:8];
        _badgeLabe.textColor = [UIColor whiteColor];
        _badgeLabe.layer.cornerRadius = (badgeView_W/2.0);
        _badgeLabe.layer.masksToBounds = YES;
        _badgeLabe.backgroundColor = [UIColor redColor];
        _isHideBadge = YES;
        _badgeLabe.hidden = _isHideBadge;
        [self addSubview:_badgeLabe];
    }
    return self;
}


-(void)setIsHideBadge:(BOOL)isHideBadge{
    _isHideBadge = isHideBadge;
    _badgeLabe.hidden = _isHideBadge;
}

-(void)setBadgeNum:(NSInteger)badgeNum{
    _badgeLabe.hidden = badgeNum==0 ? YES : NO;
    _badgeLabe.text = [NSString stringWithFormat:@"%ld",(long)badgeNum];
}

-(void)setBadgeColor:(UIColor *)badgeColor{
    _badgeLabe.backgroundColor = badgeColor;
}

@end


@interface HDSegmentedView ()
{
    /**标题数组*/
    NSArray *_titleItems;
    /**移动的色块*/
    CAGradientLayer *_movColorLayer;
    /**lab的宽度*/
    CGFloat _labW;
    /**lab的高度*/
    CGFloat _labH;
}

@end

@implementation HDSegmentedView
- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i=0; i!=_titleItems.count-1; i++) {
        //画分割线
        CGContextMoveToPoint(context, _labW*(i+1), 0);//起点
        CGContextAddLineToPoint(context, _labW*(i+1), self.frame.size.height);//终点
        CGContextSetLineWidth(context, 1.0f); // 线的宽度
        [_borderColor set]; // 两种设置颜色的方式都可以
    }
    CGContextStrokePath(context);
}


- (instancetype)initWithFrame:(CGRect)frame initWithItems:(NSArray *)items
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _labW = self.frame.size.width/items.count;
        _labH = self.frame.size.height;
        _borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        _colorArrays = @[[UIColor blueColor],[UIColor blueColor]];
        _titleColors = @[[UIColor grayColor],[UIColor whiteColor]];
        _colorDirectionType = ChangeColorDirection_R_L;
        
        self.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:timeValue].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 5.0f;
        self.layer.masksToBounds = YES;
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        _titleItems = items;
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    _movColorLayer = [CAGradientLayer layer];
    _movColorLayer.frame = (CGRect){0,0,_labW,_labH};
    _movColorLayer.colors = @[(__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor blueColor].CGColor];
    _movColorLayer.startPoint = CGPointMake(0, 0);
    _movColorLayer.endPoint = CGPointMake(1, 1);
    [self.layer addSublayer:_movColorLayer];

    for (int i=0; i!=_titleItems.count; i++) {
        HDSegmentedViewLabel *label = [[HDSegmentedViewLabel alloc]initWithFrame:(CGRect){_labW*i,0,_labW,_labH}];
        label.userInteractionEnabled = YES;
        label.tag = i+100;
        label.text = _titleItems[i];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickIndext:)];
        [label addGestureRecognizer:gesture];
        if (i==0) {
            label.userInteractionEnabled = NO;
            label.textColor = _titleColors[1];
        }
        [self addSubview:label];
    }
}

-(void)clickIndext:(UITapGestureRecognizer *)gesture{
    
    HDSegmentedViewLabel *titleLable = (HDSegmentedViewLabel *)gesture.view;
    NSInteger tag = titleLable.tag-100;
    self.DidSelectSegmentedViewIndex(tag);
    [self changeMovColorLayer:titleLable];
}

#pragma mark 改变色块的位置
-(void)changeMovColorLayer:(HDSegmentedViewLabel *)titleLable{
    
    for (int i=0; i!=_titleItems.count; i++) {
        HDSegmentedViewLabel *label = [self viewWithTag:i+100];
        label.userInteractionEnabled = YES;
        label.textColor = _titleColors[0];
    }
    titleLable.userInteractionEnabled = NO;
    titleLable.textColor = _titleColors[1];

    NSInteger tag = titleLable.tag-100;
    __weak typeof(_movColorLayer) _weakMov = _movColorLayer;
    [UIView animateWithDuration:timeValue animations:^{
        _weakMov.frame = (CGRect){tag * _labW,0,_labW,_labH};
    }];
}

#pragma mark 设置选中的木块
-(void)setSelectIndex:(NSInteger)selectIndex{
    _selectIndex = selectIndex;
    HDSegmentedViewLabel *titleLable = [self viewWithTag:(selectIndex +100)];
    [self changeMovColorLayer:titleLable];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeValue * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        titleLable.isHideBadge = YES;
    });
    
}
#pragma mark 设置渐变色数组
-(void)setColorArrays:(NSArray *)colorArrays{
    _movColorLayer.colors = @[(__bridge id)[(UIColor*)colorArrays[0] CGColor],(__bridge id)[(UIColor*)colorArrays[1] CGColor]];
}
#pragma mark 设置渐变色渐变方向
-(void)setColorDirectionType:(ChangeColorDirection)colorDirectionType{
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (colorDirectionType == ChangeColorDirection_U_D) {//上到下
        startPoint = (CGPoint){0,0};
        endPoint = (CGPoint){0,1};
        
    }else if (colorDirectionType == ChangeColorDirection_D_U){
        startPoint = (CGPoint){0,1};
        endPoint = (CGPoint){0,0};
    
    }else if (colorDirectionType == ChangeColorDirection_L_R){
        startPoint = (CGPoint){0,0};
        endPoint = (CGPoint){1,0};
    
    }else{
        startPoint = (CGPoint){1,0};
        endPoint = (CGPoint){0,0};
    }
    _movColorLayer.startPoint = startPoint;
    _movColorLayer.endPoint = endPoint;
}
#pragma mark 设置线框的颜色
-(void)setBorderColor:(UIColor *)borderColor{
    
    _borderColor = borderColor;
    self.layer.borderColor = borderColor.CGColor;
    [self setNeedsDisplay];
}
#pragma mark 设置显示指定的badge
-(void)setShowBadgeIndex:(NSInteger)showBadgeIndex{
    
    HDSegmentedViewLabel *label = [self viewWithTag:showBadgeIndex + 100];
    label.isHideBadge = NO;
}
#pragma mark 设置显示指定的badge 以及提醒的数字
-(void)setShowBadgeIndex:(NSInteger)index andBadgeNum:(NSInteger)num{
    HDSegmentedViewLabel *label = [self viewWithTag:index + 100];
    label.isHideBadge = NO;
    label.badgeNum = num;
}

#pragma mark 改变badge的颜色
-(void)setBadgeColor:(UIColor *)badgeColor{
    
    for (int i=0; i!=_titleItems.count; i++) {
        HDSegmentedViewLabel *label = [self viewWithTag:i+100];
        label.badgeColor = badgeColor;
    }
}

#pragma mark 标题的颜色 0：默认的颜色 1：选中的颜色
-(void)setTitleColors:(NSArray *)titleColors{
    _titleColors = titleColors;
}



@end
