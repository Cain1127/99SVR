//
//  WWSideslipViewController.m
//  WWSideslipViewControllerSample
//
//  Created by 王维 on 14-8-26.
//  Copyright (c) 2014年 wangwei. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "WWSideslipViewController.h"
#import "IndexViewController.h"

@interface WWSideslipViewController ()
{
    UIViewController *otherControl;
    UIView *clearView;
    IndexViewController *indexController;
}

@end

@implementation WWSideslipViewController

@synthesize speedf,sideslipTapGes;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initParams];
}

-(void)initParams
{
    [self initRegisterNotification];
}

-(void)gotoMyInfoViewCotroller:(NSNotification *)notify
{
    [self showMainView];
    [self gotoInfoViewWithTag:[notify.object intValue]];
}

-(void)gotoInfoViewWithTag:(int)nTag
{
//    IndexViewController *index = (IndexViewController*)mainControl;
    switch (nTag)
    {
//        case 1000:
//        {
//            [index showMainView];
//        }
//            break;
//        case 1001:
//        {
//            [index showRecordView];
//        }
//        break;
//        case 1002:
//        {
//            [index showRecordView];
//            [index showLocalRecord];
//        }
//        break;
//        case 1003:
//        {
//            [index showSettingView];
//        }
//        default:
//        {
//            
//        }
//        break;
    }
}

-(void)initRegisterNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoMyInfoViewCotroller:) name:MESSAGE_SHOW_MAIN_VC object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftView) name:MESSAGE_SHOW_LEFT_VC object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(instancetype)initWithLeftView:(UIViewController *)LeftView
                    andMainView:(UIViewController *)MainView
                   andRightView:(UIViewController *)RighView
             andBackgroundImage:(UIImage *)image;
{
    if(self)
    {
        speedf = 0.5;
        
        leftControl = LeftView;
        mainControl = MainView;
        righControl = RighView;
        
        UIImageView * imgview = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [imgview setImage:image];
        [self.view addSubview:imgview];
        
        //滑动手势
        UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [mainControl.view addGestureRecognizer:pan];
        //单击手势
        sideslipTapGes= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMainView)];
        [sideslipTapGes setNumberOfTapsRequired:1];
        
        righControl.view.hidden = YES;
        
        clearView = [[UIView alloc] initWithFrame:mainControl.view.bounds];
        [clearView setBackgroundColor:[UIColor clearColor]];
        [clearView setUserInteractionEnabled:YES];
        [clearView addGestureRecognizer:sideslipTapGes];
        
        [self addChildViewController:mainControl];
        [self addChildViewController:leftControl];
        
        [self.view addSubview:leftControl.view];
        [self.view addSubview:righControl.view];
        [self.view addSubview:mainControl.view];
        
        indexController = (IndexViewController *)mainControl;
        
    }
    return self;
}
#pragma mark - 滑动手势
- (void) handlePan: (UIPanGestureRecognizer *)rec
{
    CGPoint point = [rec translationInView:self.view];
    scalef = (point.x*speedf+scalef);
    if (rec.view.frame.origin.x>=0)
    {
//        rec.view.center = CGPointMake(rec.view.center.x + point.x*speedf,rec.view.center.y);
//        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1-scalef/1000,1-scalef/1000);
        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
        leftControl.view.hidden = NO;
    }
    else
    {
        //右滑
//        rec.view.center = CGPointMake(rec.view.center.x + point.x*speedf,rec.view.center.y);
//        rec.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1+scalef/1000,1+scalef/1000);
//        [rec setTranslation:CGPointMake(0, 0) inView:self.view];
    }
    //手势结束后修正位置
    if (rec.state == UIGestureRecognizerStateEnded)
    {
        if(clearView.superview == mainControl.view)
        {
            [self showMainView];
            scalef = 0;
        }
        else
        {
            [self showMainView];
            scalef = 0;
        }
    }
}


#pragma mark - 单击手势
-(void)handeTap:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:nil context:nil];
        tap.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
        tap.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
        [UIView commitAnimations];
        scalef = 0;
        if (otherControl)
        {
            otherControl = nil;
        }
    }
}

#pragma mark - 修改视图位置
//恢复位置
-(void)showMainView
{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    mainControl.view.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];

    [clearView removeFromSuperview];
}

//显示左视图
-(void)showLeftView
{
    [UIView beginAnimations:nil context:nil];
    mainControl.view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.85,1);
    mainControl.view.center = CGPointMake(kScreenSourchWidth*1.25,[UIScreen mainScreen].bounds.size.height/2);
    [UIView commitAnimations];
    [mainControl.view addSubview:clearView];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 重力感应设置
-(BOOL)shouldAutorotate
{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end