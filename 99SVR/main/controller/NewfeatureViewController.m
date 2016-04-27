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
        NSString *name=[NSString stringWithFormat:@"guide-%d",i+1];
        if (kiPhone4_OR_4s) {
            name = [name stringByAppendingString:@"-m"];
        } else if(kiPhone5_OR_5c_OR_5s){
            name = [name stringByAppendingString:@"-xl"];
        } else if(kiPhone6_OR_6s){
            name = [name stringByAppendingString:@"-md"];
        } else if(kiPhone6Plus_OR_6sPlus){
            name = [name stringByAppendingString:@"-xxl"];
        } else{
            name = [name stringByAppendingString:@"-xxl"];
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
    //pageControl.currentPageIndicatorTintColor=Color_F24979;
    pageControl.centerX=self.view.width * 0.5;
    pageControl.centerY=self.view.height * 0.96;
//    [pageControl setValue:[UIImage imageNamed:@"line-not-click"] forKeyPath:@"_pageImage"];
//    [pageControl setValue:[UIImage imageNamed:@"line-click"] forKeyPath:@"_currentPageImage"];
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
    startBtn.layer.borderWidth = 0.5;
    startBtn.layer.borderColor = [UIColor redColor].CGColor;//Color_FFFFFF.CGColor;
    startBtn.alpha = 0.8;
    [startBtn setTitle:@"立马启动" forState:UIControlStateNormal];
    startBtn.titleLabel.textColor = [UIColor blackColor];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    startBtn.titleLabel.alpha = 0.9;
    
    startBtn.centerX=imageView.width*0.5;
    startBtn.centerY=imageView.height*0.76;
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
    app.window.rootViewController =  [[TabBarController alloc] init];
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
