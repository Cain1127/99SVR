

#import "SliderMenuTopScrollView.h"
#define titleSelectColor UIColorFromRGB(0x0078dd)//字体选中的颜色
#define titleNormalColor UIColorFromRGB(0x4c4c4c)//字体默认的颜色
#define badgeView_W 10


@interface SliderLabel ()
@property (nonatomic, strong) UIView *badgeView;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation SliderLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //默认是不显示Badge
        _isHideBadge = YES;
        
    
        
        self.badgeView = [[UIView alloc]initWithFrame:(CGRect){10,10,badgeView_W,badgeView_W}];
        self.badgeView.layer.cornerRadius = (badgeView_W/2.0);
        self.badgeView.layer.masksToBounds = YES;
        self.badgeView.backgroundColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
        
        //背景色
        self.backgroundView = [[UIView alloc]init];
        [self addSubview:self.backgroundView];
        
        [self addSubview:self.badgeView];
    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.backgroundView.frame = (CGRect){0,0,width,height};
    self.badgeView.frame = (CGRect){width - 10,0,badgeView_W,badgeView_W};
    self.badgeView.hidden = _isHideBadge;
    
}

-(void)setIsHideBadge:(BOOL)isHideBadge{
    
    _isHideBadge = isHideBadge;
    self.badgeView.hidden = _isHideBadge;
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    
    self.backgroundView.backgroundColor = backgroundColor;
}

-(void)setBadgeColor:(UIColor *)badgeColor{
    
    self.badgeView.backgroundColor = badgeColor;
}

@end




#pragma mark =================================== 滑动的标题 ================================

@interface SliderMenuTopScrollView ()
{
    NSArray *_titleArrays;
    /**记录上个titleLabel的x位置*/
    CGFloat _lastTitleLabel_x;
    /**title的间隔*/
    CGFloat _jiange;
    //self 的高度
    CGFloat _selfHeight;
    //self 的宽度
    CGFloat _selfWidth;
    //字体大小
    CGFloat _titleFont;
    //字体宽度比实际宽
    CGFloat _titleOffset;
    //linview 下划线比标签左右的偏移量
    CGFloat _lineViewOffset;
    //默认选择的模块
    CGFloat _selectIndex;
    /**顶部按钮下划线动画滑动的时间*/
    CGFloat _animationTime;
}
/**文字底部下划线*/
@property (nonatomic, strong) UIView *lineView;
//存储每个title的orginX值 滑动底部时候 顶部滑动更顺畅
@property (nonatomic, strong) NSMutableArray *titleOrginXArrays;
/**底部的界线*/
@property (nonatomic , strong) UIView *bottomLineView;
@end
@implementation SliderMenuTopScrollView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withDefaultSelectIndex:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //取消横竖的滑动滚动条
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        _titleArrays = titles;
        _lastTitleLabel_x = 0;
        _selfHeight = frame.size.height;
        _selfWidth = frame.size.width;
        _titleFont = 15;
        _lineViewOffset = 5;
        _titleOffset = 20;
        _selectIndex = index;
        _animationTime = 0.5;
        self.bottomLineView.backgroundColor = COLOR_Line_Small_Gay;
        [self calculateJianGeWithTitleArrays:titles];
        [self createTitle];
        
    }
    return self;
}

-(void)calculateJianGeWithTitleArrays:(NSArray *)titleArrays{
    
    NSMutableString *muStr = [[NSMutableString alloc]initWithString:@""];
    
    for (int i=0; i!=titleArrays.count; i++) {
        NSString *str = titleArrays[i];
        [muStr appendString:str];
    }
    SliderLabel *titleLabel = [[SliderLabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:_titleFont];
    titleLabel.text = muStr;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    
    //计算间隔
    CGFloat title_W = titleLabel.frame.size.width + _titleOffset*titleArrays.count;
    if (title_W<_selfWidth) {
        _jiange = (_selfWidth - title_W)/(titleArrays.count+1);
        
    }else{
        _jiange = 40;
    }
}

#pragma mark 创建标题
-(void)createTitle{
    
    for (int i=0; i!=_titleArrays.count; i++) {
        SliderLabel *titleLabel = [[SliderLabel alloc]init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:_titleFont];
        titleLabel.text = _titleArrays[i];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [titleLabel sizeToFit];
        titleLabel.frame = (CGRect){_lastTitleLabel_x+_jiange,(_selfHeight-30)/2.0,titleLabel.frame.size.width + _titleOffset,20 + 10};
        _lastTitleLabel_x = CGRectGetMaxX(titleLabel.frame);
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.userInteractionEnabled = YES;
        titleLabel.tag = i+1;
        [titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)]];
        
        if (i==_selectIndex) {
            titleLabel.textColor = titleSelectColor;
            titleLabel.userInteractionEnabled = NO;
            self.lineView.frame = (CGRect){CGRectGetMinX(titleLabel.frame) - (_lineViewOffset),_selfHeight-1,CGRectGetWidth(titleLabel.frame)+ (2*_lineViewOffset),2};
        }
        
        if (i==_titleArrays.count-1) {
            self.contentSize = CGSizeMake(CGRectGetMaxX(titleLabel.frame) + _jiange, _selfHeight);
        }
        [self addSubview:titleLabel];
    }
    
    //计算各个titleFrame的值
    for (int i=0 ; i!=_titleArrays.count; i++) {
        SliderLabel *label = [self viewWithTag:i+1];
        CGFloat orginX = CGRectGetMinX(label.frame);
        [self.titleOrginXArrays addObject:@(orginX)];
    }
}




#pragma mark

-(NSMutableArray *)titleOrginXArrays{
    if (!_titleOrginXArrays) {
        _titleOrginXArrays = [NSMutableArray array];
    }
    return _titleOrginXArrays;
}

-(UIView *)lineView{
    
    if (!_lineView) {
     
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = titleSelectColor;
        [self addSubview:_lineView];
    }
    return _lineView;
}

-(UIView *)bottomLineView{
    
    if (!_bottomLineView) {
        
        _bottomLineView = [[UIView alloc]initWithFrame:(CGRect){0,self.height-0.5,self.width,0.5}];
        [self addSubview:_bottomLineView];
    }
    
    return _bottomLineView;
}


/** 标题栏label的点击事件 */
- (void)titleLabelClick:(UITapGestureRecognizer *)recognizer
{
    SliderLabel *titleLable = (SliderLabel *)recognizer.view;

    NSInteger tag = titleLable.tag;
    
    for (int i=0; i!=_titleArrays.count; i++) {
        SliderLabel *label = [self viewWithTag:i+1];
        label.userInteractionEnabled = YES;
        label.textColor = tag==(i+1)? titleSelectColor : titleNormalColor;
    }
    titleLable.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:_animationTime animations:^{
        
        self.lineView.frame = (CGRect){CGRectGetMinX(titleLable.frame) - _lineViewOffset,_selfHeight-1,CGRectGetWidth(titleLable.frame)+ (2*_lineViewOffset),2};
    }];
    
    if (self.contentSize.width > _selfWidth) {
            // 滚动标题栏
            CGFloat offsetx = titleLable.center.x - self.frame.size.width * 0.5;
            CGFloat offsetMax = self.contentSize.width - self.frame.size.width;
            if (offsetx < 0) {
                offsetx = 0;
            }else if (offsetx > offsetMax){
                offsetx = offsetMax;
            }
            CGPoint offset = CGPointMake(offsetx, self.contentOffset.y);
            [self setContentOffset:offset animated:YES];
    }
        
    self.DidSelectSliderIndex(tag);
}


-(void)setLineViewOriginX:(CGFloat)originx withIndex:(NSInteger)index{

    //目标label
    SliderLabel *titleLable = [self viewWithTag:index +1];
    //对于的index
    int titelIndex = (int)(originx/_selfWidth);
    
    //前后两个title的 origniX的间隔
    CGFloat jiange_X = 0;
    if (titelIndex!=self.titleOrginXArrays.count-1) {
        jiange_X = [self.titleOrginXArrays[titelIndex+1] floatValue] - [self.titleOrginXArrays[titelIndex] floatValue];
    }else{
        jiange_X = [self.titleOrginXArrays[titelIndex] floatValue] - [self.titleOrginXArrays[titelIndex-1] floatValue];
    }
    NSString *decimalStr = [NSString stringWithFormat:@"%f",originx/_selfWidth];
    //这里是做数据的处理 只要小数点后的数字 然后在拼接0.
    NSArray *decimalStrArray = [decimalStr componentsSeparatedByString:@"."];
    NSString *tempDecimalStr = nil;
    if (decimalStrArray.count==2) {
        tempDecimalStr = [NSString stringWithFormat:@"0.%@",decimalStrArray[1]];
    }
    
    
    CGFloat lineViewOrginX = [self.titleOrginXArrays[titelIndex] floatValue] + (jiange_X * [tempDecimalStr floatValue])- _lineViewOffset;
    
//    NSLog(@"下标%d 变化%@  下标的对应值%f 偏移量%f 坐标%f",titelIndex,tempDecimalStr,[self.titleOrginXArrays[titelIndex] floatValue],(jiange_X * [tempDecimalStr floatValue]),lineViewOrginX);
    [UIView animateWithDuration:_animationTime animations:^{
        self.lineView.frame = (CGRect){lineViewOrginX,_selfHeight-1,CGRectGetWidth(titleLable.frame)+(2*_lineViewOffset),2};
    }];
    
    
    //滚动标题栏
    if (self.contentSize.width > _selfWidth) {
        // 滚动标题栏
        CGFloat offsetx = titleLable.center.x - self.frame.size.width * 0.5;
        CGFloat offsetMax = self.contentSize.width - self.frame.size.width;
        if (offsetx < 0) {
            offsetx = 0;
        }else if (offsetx > offsetMax){
            offsetx = offsetMax;
        }
        CGPoint offset = CGPointMake(offsetx, self.contentOffset.y);
        [self setContentOffset:offset animated:YES];
    }

    for (int i=0; i!=_titleArrays.count; i++) {
        SliderLabel *label = [self viewWithTag:i+1];
        label.userInteractionEnabled = YES;
        label.textColor = index==(i)? titleSelectColor : [UIColor grayColor];
    }
    titleLable.userInteractionEnabled = NO;
}
#pragma mark 指定的title是否显示红点提示
-(void)setTitleIndex:(NSInteger)index badgeHide:(BOOL)value{
    //目标label
    SliderLabel *titleLable = [self viewWithTag:index];
    titleLable.isHideBadge = value;
}
#pragma mark 提供给外部修改badge的颜色
-(void)setTitleBadgeColor:(UIColor *)color{
    for (int i=0; i!=self.subviews.count; i++) {
        UIView *view = [self viewWithTag:i];
        if ([view isKindOfClass:[SliderLabel class]]) {
            SliderLabel *sliderLabel = (SliderLabel *)view;
            sliderLabel.badgeColor = color;
        }
    }
}

#pragma mark 提供给外部修改标题背景的颜色
-(void)setTitleBagColor:(UIColor *)color{
    for (int i=0; i!=self.subviews.count; i++) {
        UIView *view = [self viewWithTag:i];
        if ([view isKindOfClass:[SliderLabel class]]) {
            SliderLabel *sliderLabel = (SliderLabel *)view;
            sliderLabel.backgroundColor = color;
        }
    }
}

#pragma mark 提供给外部修改顶部按钮下划线动画滑动的时间
-(void)setAnimationTime:(CGFloat )timeFloat{
    _animationTime = timeFloat;
}



/**
 *  重写手势，如果是左滑，则禁用掉scrollview自带的
 */
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        if([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0.0f)
        {
            return NO;
        }
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end







