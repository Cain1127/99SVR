




#import "DDLineChartView.h"

@interface DDLineChartView ()
{
    
    CGFloat _width;
    CGFloat _height;
    
    /**最大值*/
    CGFloat _valueMax_Y;
    /**最小值*/
    CGFloat _valueMin_Y;
    
}

@property (nonatomic, strong) NSMutableArray *chartLines;

@end



@implementation DDLineChartView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = frame.size.width;
        _height = frame.size.height;
        /**画线的时间*/
        _timeValue = 1.f;
    }
    return self;
}

#pragma mark 目标值
-(void)setTargetValue_Y:(CGFloat)targetValue_Y{
    
    CGFloat point_y = ((fabs(_valueMax_Y - targetValue_Y))/(_valueMax_Y - _valueMin_Y))*(_height);
    CGPoint point = CGPointMake(0, point_y);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point];
    [path addLineToPoint:CGPointMake(_width,point_y)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [[[UIColor blackColor] colorWithAlphaComponent:1] CGColor];
    shapeLayer.fillColor = [[UIColor blackColor] CGColor];
    shapeLayer.lineWidth = 1;
    [self.layer addSublayer:shapeLayer];
}

#pragma mark 画横线
-(void)setDrawLine_X:(BOOL)drawLine_X{
    
    _drawLine_X = drawLine_X;
}

-(void)setLevel_Y:(NSInteger)level_Y{
    
    _level_Y = level_Y;
    
    //间隔
    CGFloat offsetX = _height/_level_Y;
    if (_drawLine_X) {
        //画横线
        for (int i=0; i!=_level_Y; i++) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(0,i*offsetX)];
            [path addLineToPoint:CGPointMake(_width,i*offsetX)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor = COLOR_Line_Small_Gay.CGColor;
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = LineView_Height;
            [self.layer addSublayer:shapeLayer];
        }
    }

}
#pragma mark 画竖线
-(void)setDrawLine_Y:(BOOL)drawLine_Y{
    
    _drawLine_Y = drawLine_Y;
}

-(void)setRaneValue_X:(CGRange)raneValue_X{
    
    _raneValue_X = raneValue_X;
}

-(void)setLevel_X:(NSInteger)level_X{
    
    _level_X = level_X;
    //间隔
    CGFloat offsetX = _width/(_level_X);
    if (_drawLine_Y) {
        //画竖线
        for (int i=0; i!=_level_X; i++) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:CGPointMake(i*offsetX,0)];
            [path addLineToPoint:CGPointMake(i*offsetX,_height)];
            [path closePath];
            shapeLayer.path = path.CGPath;
            shapeLayer.strokeColor =  COLOR_Line_Small_Gay.CGColor;
            shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
            shapeLayer.lineWidth = LineView_Height;
            [self.layer addSublayer:shapeLayer];
        }
    }
}


#pragma mark Y的数据
-(void)setValuePoints_Y:(NSArray *)valuePoints_Y{
    
    _valuePoints_Y = valuePoints_Y;
}

-(void)setRaneValue_Y:(CGRange)raneValue_Y{
    
    _raneValue_Y = raneValue_Y;
    
    if (_raneValue_Y.min!=_raneValue_Y.max) {
        _valueMax_Y = _raneValue_Y.max;
        _valueMin_Y = _raneValue_Y.min;
    }
}

-(void)setLineColors:(NSArray *)lineColors{
    
    _lineColors = lineColors;
}

#pragma mark 画线
-(void)drawLine{

    //整合y的数据 因为坐标系问题。所以，需要进行处理。uivew的坐标系是左上角是（0,0）x往右递增，y往下递增。但是在股票走势图来说。x不变，但是y必须是往上递增。
    
    if (_valuePoints_Y.count==0) {
        return;
    }
    
    [self.chartLines removeAllObjects];
    
    for (int i=0; i!=_valuePoints_Y.count; i++) {
    
        [self drawLineWithValueArraysIndex:i];
    }
    
}
#pragma mark 取出一个数组的值
-(void)drawLineWithValueArraysIndex:(NSInteger)index{

    //数据源
    NSArray *arrays = _valuePoints_Y[index];
    //线的颜色
    CGColorRef lineColor = [[_lineColors objectAtIndex:index] CGColor];
    
    
    //遍历数据找到最大值，最小值
//    CGFloat minY = [arrays[0] floatValue];
//    CGFloat maxY = [arrays[0] floatValue];
//    
//    for (int j=0; j!=arrays.count; j++){
//        CGFloat num = [arrays[j] floatValue];
//        if (maxY<=num){
//            maxY = num;
//        }
//        if (minY>=num){
//            minY = num;
//        }
//    }
    
    
    CGFloat scale_x = (_width/(arrays.count-1)/1.0);
    CAShapeLayer *chartLine = [CAShapeLayer layer];
    chartLine.lineCap = kCALineCapRound;
    chartLine.lineJoin = kCALineJoinBevel;
    chartLine.fillColor   = [[UIColor whiteColor] CGColor];
    chartLine.lineWidth   = 1.0;
    chartLine.strokeEnd   = 0.0;
    chartLine.strokeColor = lineColor;
    [self.layer addSublayer:chartLine];
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    //计算坐标点
    for (int i=0; i!=arrays.count; i++) {
        //x坐标
        CGFloat point_x = scale_x *i;
        CGFloat tempValueY = [arrays[i] floatValue];
        //Y坐标
        CGFloat point_y = ((fabs(_valueMax_Y - tempValueY))/(_valueMax_Y - _valueMin_Y))*(_height);
        CGPoint point = CGPointMake(point_x, point_y);
        if (i==0) {//添加第一个点
            
            [progressline moveToPoint:point];
        }
        [progressline addLineToPoint:point];
        [progressline moveToPoint:point];
    }
    
    chartLine.path = progressline.CGPath;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = self.timeValue;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画开始时间时间
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    chartLine.strokeEnd   = 1.0;

    [self.chartLines addObject:chartLine];
}

-(NSMutableArray *)chartLines{
    
    if (!_chartLines) {
        
        _chartLines = [NSMutableArray array];
    }
    return _chartLines;
}
#pragma mark 清空画线
-(void)clearLine{

    for (CAShapeLayer *chartLine in self.chartLines) {
        
        if (chartLine) {
            
            [chartLine removeFromSuperlayer];
        }
    }
}


@end
