
#define EmptyViewTag 99999


#import "UIViewController+EmpetViewTips.h"

@implementation UIViewController (EmpetViewTips)

-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg{

    
    [self showEmptyViewInView:targetView withMsg:msg withImageName:@""];
}


-(void)showErrorViewInView:(UIView *)targetView withMsg:(NSString *)msg{

    [self showEmptyViewInView:targetView withMsg:msg withImageName:@""];
}




-(void)showEmptyViewInView:(UIView *)targetView withMsg:(NSString *)msg withImageName:(NSString *)imageName{

    CGFloat width = targetView.frame.size.width;
    CGFloat height = targetView.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:(CGRect){0,0,width,height}];
    view.backgroundColor = [UIColor grayColor];
    view.tag = EmptyViewTag;
    [targetView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.frame = (CGRect){0,0,100,100};
    imageView.backgroundColor = [UIColor greenColor];
    imageView.center = CGPointMake(view.center.x, view.center.y-50);
    [view addSubview:imageView];
    
    UILabel *titLab = [[UILabel alloc]init];
    titLab.textAlignment = NSTextAlignmentCenter;
    titLab.numberOfLines = 0;
    titLab.backgroundColor = [UIColor whiteColor];
    titLab.text = msg;
    [titLab sizeToFit];
    titLab.frame = (CGRect){0,CGRectGetMaxY(imageView.frame),width,titLab.frame.size.height};
    [view addSubview:titLab];
    
}


-(void)hideEmptyViewInView:(UIView *)targetView{

    UIView *view = [targetView viewWithTag:EmptyViewTag];
    if (view) {
        [view removeFromSuperview];
    }
}



@end
