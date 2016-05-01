
#define EmptyViewTag 10086


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
//    [view setBackgroundColor:UIColorFromRGB(0xf8f8f8)];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:Rect(frame.size.width/2-image.size.width/2, frame.size.height/2-image.size.height/2, image.size.width, image.size.height)];
//    [view addSubview:imgView];
//    
//    [imgView setImage:image];
//    
//    UILabel *lblName = [[UILabel alloc] initWithFrame:Rect(0, imgView.y+imgView.height+10, kScreenWidth, 20)];
//    [lblName setTextColor:UIColorFromRGB(0x4c4c4c)];
//    [view addSubview:lblName];
//    [lblName setText:strMsg];
//    [lblName setTextAlignment:NSTextAlignmentCenter];
    
    
    
}



@end
