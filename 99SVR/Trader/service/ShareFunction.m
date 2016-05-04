

/**
 *  公共函数方法 全类通用
 */

#import "ShareFunction.h"
#import "UIAlertView+Block.h"
@implementation ShareFunction
#pragma mark 计算出字体的长度已经高度。这里不包括行距
+(CGSize)calculationOfTheText:(NSString *)string withFont:(CGFloat)font withMaxSize:(CGSize)maxSize{
    
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:font]} context:nil].size;
}
#pragma mark 计算出字体的长度已经高度。并且要设置行距。会对Lable进行处理。返回宽度和高度可以不用处理。
+(CGRect)calculationOfTheText:(NSString *)string inLabel:(UILabel *)label withFont:(CGFloat)font withMaxWidth:(CGFloat)width withLineSpacing:(CGFloat)spacing{
    //设置Label最大的宽度
    label.frame = (CGRect){label.frame.origin.x,label.frame.origin.y,width,label.frame.size.width};
    label.font = [UIFont systemFontOfSize:font];
    label.numberOfLines = 0;
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:spacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    [label setAttributedText:attributedString];
    [label sizeToFit];
    return (CGRect){label.frame.origin.x,label.frame.origin.y,label.frame.size.width,label.frame.size.height};
}
#pragma mark 设置导航条的颜色,已经隐藏导航条下面的线了
+(void)setNavigationBarColor:(UIColor *)color withTargetViewController:(id)target{
    
    UIViewController *viewController = (UIViewController *)target;
    //导航条的颜色 以及隐藏导航条的颜色
    viewController.navigationController.navigationBar.shadowImage = [[UIImage alloc]init];
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [viewController.navigationController.navigationBar setBackgroundImage:theImage forBarMetrics:UIBarMetricsDefault];
}
#pragma mark scrollView顶部视图下拉放大
/**
 *  scrollView顶部视图下拉放大
 *
 *  @param imageView  需要放大的图片
 *  @param headerView 图片所在headerView 如果没有则传图片自己本身
 *  @param height     图片的高度
 *  @param offsetY    设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
 *  @param scrollView 对应的scrollView
 */
+(void)setHeaderViewDropDownEnlargeImageView:(UIImageView *)imageView withHeaderView:(UIView *)headerView withImageViewHeight:(CGFloat)height withOffsetY:(CGFloat)offsetY withScrollView:(UIScrollView *)scrollView{
    CGFloat yOffset = scrollView.contentOffset.y;
    //向上偏移量变正  向下偏移量变负
    /**
     *  设置偏移多少开始形变  例如是：offset_y = 64 说明就是y向下偏移64像素开始放大
     宏：k_headerViewHeight 就是header的高度
     */
    CGFloat offset_y = offsetY;
    CGFloat imageHeight = height;
    
    if (yOffset < -offset_y) {
        CGFloat factor = ABS(yOffset)+imageHeight-offset_y;
        CGRect f = CGRectMake(-([[UIScreen mainScreen] bounds].size.width*factor/imageHeight-[[UIScreen mainScreen] bounds].size.width)/2,-ABS(yOffset)+offset_y, [[UIScreen mainScreen] bounds].size.width*factor/imageHeight, factor);
        imageView.frame = f;
    }else {
        CGRect f = headerView.frame;
        f.origin.y = 0;
        headerView.frame = f;
        imageView.frame = CGRectMake(0, f.origin.y, [[UIScreen mainScreen] bounds].size.width, imageHeight);
    }
}


#pragma mark 传入当前控制器 获取同一个nav里面的控制器
+(UIViewController *)getTargetViewController:(NSString *)viewControllerName withInTheCurrentController:(UIViewController *)viewController{
    NSArray *viewControllers = viewController.navigationController.viewControllers;
    id object;
    for (int i=0; i!=viewControllers.count; i++) {
        UIViewController *viewController = viewControllers[i];
        NSString *vcName = [NSString stringWithUTF8String:object_getClassName(viewController)];
        if ([vcName isEqualToString:viewControllerName]) {
            object = viewController;
        }
    }
    return (UIViewController *)object;
}

#pragma mark 传入时间戳1296057600和输出格式 yyyy-MM-dd HH:mm:ss
+ (NSString *)dateWithTimeIntervalSince1970:(NSTimeInterval)seconds dateStringWithFormat:(NSString *)format {
    
    // Timestamp conver NSData
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds];
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:format];
    return [dateFormatte stringFromDate:date];
}

#pragma mark 小到大
+(NSMutableArray *)sortOfSmallToBig:(NSArray *)array{
    
    NSMutableArray *muArray = [NSMutableArray arrayWithArray:array];
    for (int i = 0; i < muArray.count; i++) {
        for (int j = 0; j < muArray.count - i - 1;j++) {
            if ([muArray[j+1]floatValue] < [muArray[j] floatValue]) {
                float temp = [muArray[j] floatValue];
                muArray[j] = muArray[j + 1];
                muArray[j + 1] = [NSString stringWithFormat:@"%f",temp];
            }
        }
    }
    return muArray;
}


+(NSArray *)returnMinandMaxWithArrayA:(NSArray *)arrA withArrayB:(NSArray *)arrB{

    
    NSMutableArray *muArrayA = [ShareFunction sortOfSmallToBig:arrA];
    NSMutableArray *muArrayB = [ShareFunction sortOfSmallToBig:arrB];
    
    float minA = [[muArrayA firstObject] floatValue];
    float maxA = [[muArrayA lastObject] floatValue];

    float minB = [[muArrayB firstObject] floatValue];
    float maxB = [[muArrayB lastObject] floatValue];
    
    float min = 0.0;
    float max = 0.0;
    if (minA>minB) {
        min = minB;
    }else{
        min = minA;
    }
    
    if (maxA>maxB) {
        max = minA;
    }else{
        max = maxB;
    }
    return @[[NSString stringWithFormat:@"%f",((min -1.0))],[NSString stringWithFormat:@"%f",(max+1.0)]];
}


@end
