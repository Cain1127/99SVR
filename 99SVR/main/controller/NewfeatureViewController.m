//
//  NewfeatureViewController.m
//  99SVR
//
//  Created by jiangys on 16/4/23.
//  Copyright © 2016年 Jiangys . All rights reserved.
//

#import "NewfeatureViewController.h"
#import "AppDelegate.h"
#import "TabBarController.h"
#import "SwitchRootTool.h"


// 新特性图片总数
#define NewfeatureCount 4

@interface NewfeatureViewController ()<UIScrollViewDelegate>

/** 滑动图片 分页 */
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation NewfeatureViewController

- (id)init {
    self = [super init];
    if (self) {
        // 1.添加UISrollView
        [self setupScrollView];
        
        // 2.添加pageControl
        [self setupPageControl];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


// 隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/**
 *  添加UISrollView
 */
- (void)setupScrollView
{
    UIScrollView *scrollView=[[UIScrollView alloc] init];
    scrollView.frame=self.view.bounds;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    
    CGFloat scrollW=scrollView.width;
    CGFloat scrollH=scrollView.height;
    for (int i=0; i < NewfeatureCount;i++) {
        UIImageView *imageView=[[UIImageView alloc] init];
        imageView.width=scrollW;
        imageView.height=scrollH;
        imageView.y=0;
        imageView.x=i*scrollW;
        
        // 显示图片
        NSString *name=[NSString stringWithFormat:@"iPhone6_%d@2x",i+1];
        if (kiPhone4_OR_4s) {
            name = [NSString stringWithFormat:@"iPhone4_%d@2x",i+1];
        } else if(kiPhone5_OR_5c_OR_5s||kiPhone6_OR_6s){
            name = [NSString stringWithFormat:@"iPhone6_%d@2x",i+1];
        } else if(kiPhone6Plus_OR_6sPlus){
            name = [NSString stringWithFormat:@"iPhone6P_%d@3x",i+1];
        }
        // 为了释放图片内存，imageWithContentsOfFile 代替 [UIImage imageNamed:name];
        imageView.image = kPNG_IMAGE_FILE(name);
        if (i==(NewfeatureCount-1)) {
            [self setupLastImageView:imageView];
        }
        
        [scrollView addSubview:imageView];
    }
    
    // 3.设置scrollView的其他属性
    scrollView.contentSize = CGSizeMake(NewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; // 去除弹簧效果
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
}

/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    UIPageControl *pageControl=[[UIPageControl alloc] init];
    pageControl.numberOfPages=NewfeatureCount;
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0x777777);
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xe9542f);
    pageControl.centerX=self.view.width * 0.5;
    pageControl.centerY=self.view.height * 0.96;
    [self.view addSubview:pageControl];
    self.pageControl=pageControl;
}

/**
 *  初始化最后一个imageView
 *
 *  @param imageView 最后一个imageView
 */
- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互
    imageView.userInteractionEnabled=YES;
    
    // 立即开始
    UIButton *startBtn=[[UIButton alloc] init];
    startBtn.backgroundColor = [UIColor clearColor];
    startBtn.size = CGSizeMake(94, 32);
    startBtn.clipsToBounds = YES;
    startBtn.layer.cornerRadius = 3;
    [startBtn setTitle:@"马上体验" forState:UIControlStateNormal];
    startBtn.titleLabel.textColor = [UIColor whiteColor];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    startBtn.backgroundColor = UIColorFromRGB(0xe8524f);
    
    startBtn.centerX=imageView.width*0.5;
    startBtn.centerY=imageView.height*0.88;
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
}

/**
 *  启动
 */
- (void)startClick
{
    // 切换到TabBarController
    [SwitchRootTool saveCurrentVersion];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.window.rootViewController =  [TabBarController singletonTabBarController];
}

#pragma ScrollView 代理

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 获取页码
    CGFloat doublePage=scrollView.contentOffset.x/scrollView.width;
    NSUInteger intPage=(NSUInteger)(doublePage+0.5);
    
    // 设置页码
    self.pageControl.currentPage=intPage;
}


@end
