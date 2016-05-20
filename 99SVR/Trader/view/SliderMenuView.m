
#import "SliderMenuView.h"
#import "SliderMenuTopScrollView.h"




#define weakSelf(Target) __weak typeof(Target) weakself = Target


@interface SliderMenuBottomScroView ()


@end

@implementation SliderMenuBottomScroView

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


@interface SliderMenuView ()<UIScrollViewDelegate>
{
    /**当前view高度*/
    CGFloat _self_H;
    /**当前view宽度*/
    CGFloat _self_W;
    /**顶部scroViewFrame*/
    CGRect _topScroV_F;
    /**底部scroViewFrame*/
    CGRect _bottomoScroV_F;
    /**记录上次的值*/
    __block NSInteger _lastInt;
    //记录滑动之后的 值
    __block NSInteger _lastSelectIndex;
    /**记录第一次初始化时 setContentOffset*/
    BOOL _isFirstInit;
    /**标题的个数*/
    NSInteger _titleInteger;
}
@property (nonatomic, strong) SliderMenuTopScrollView *topScroView;
//@property (nonatomic, strong) UIScrollView *bottomScroView;
/**是否要回调 不判断会出现 点顶部按钮会有两个回调的事件*/
@property (nonatomic, assign) __block BOOL isHandle;

@end

@implementation SliderMenuView


- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles withDefaultSelectIndex:(NSInteger)selectIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        self.isHandle = YES;
        _self_W = frame.size.width;
        _self_H = frame.size.height;
        _topScroV_F = (CGRect){0,0,_self_W,40};
        _bottomoScroV_F = (CGRect){0,CGRectGetMaxY(_topScroV_F),_self_W,(_self_H-CGRectGetMaxY(_topScroV_F))};
        _lastSelectIndex = selectIndex;
        _titleInteger = titles.count;
        //顶部控制menu
        self.topScroView = [[SliderMenuTopScrollView alloc] initWithFrame:_topScroV_F withTitles:titles withDefaultSelectIndex:(selectIndex-1)];
        [self addSubview:self.topScroView];
        weakSelf(self);
        self.topScroView.DidSelectSliderIndex = ^(NSInteger index){
            weakself.isHandle = NO;
            [weakself.bottomScroView setContentOffset:(CGPoint){(index-1)*_self_W,0} animated:NO];
            [weakself hanleBlockWith:index];
            _lastSelectIndex = index;
            [weakself.topScroView setTitleIndex:index badgeHide:YES];
            weakself.isHandle = YES;
        };
        //底部视图
        _isFirstInit = YES;
        [self addSubview:self.bottomScroView];
        [self.bottomScroView setContentOffset:(CGPoint){(selectIndex-1)*_self_W,0} animated:YES];
        _isFirstInit = NO;

    }
    return self;
}

-(void)hanleBlockWith:(NSInteger)index
{
    
    if (_lastSelectIndex!=index) {
        self.DidSelectSliderIndex(index);
        _lastSelectIndex = index;
    }
}


-(UIScrollView *)bottomScroView{
    
    if (!_bottomScroView) {
        _bottomScroView = [[SliderMenuBottomScroView alloc]initWithFrame:_bottomoScroV_F];
        _bottomScroView.bounces = NO;
        _bottomScroView.pagingEnabled = YES;
        _bottomScroView.showsHorizontalScrollIndicator = NO;
        _bottomScroView.showsVerticalScrollIndicator = NO;
        _bottomScroView.delegate = self;
    }
    return _bottomScroView;
}

-(void)setViewArrays:(NSArray *)viewArrays{
    _viewArrays = viewArrays;
    self.bottomScroView.contentSize = (CGSize){viewArrays.count*_self_W,_bottomoScroV_F.size.height};
    for (int i =0; i!=viewArrays.count; i++) {
        UIView *targetView = (UIView *)viewArrays[i];
        targetView.frame = (CGRect){i*_self_W,0,_self_W,CGRectGetHeight(self.bottomScroView.frame)};
        [self.bottomScroView addSubview:targetView];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (!_isFirstInit) {
        NSString *index = [NSString stringWithFormat:@"%.0f",scrollView.contentOffset.x/_self_W];
        [self.topScroView setLineViewOriginX:scrollView.contentOffset.x withIndex:[index integerValue]];
        weakSelf(self);
        if (self.isHandle) {
            if (_lastInt!=[index intValue]) {
                _lastInt = [index intValue];
                [weakself hanleBlockWith:(_lastInt+1)];
                [weakself.topScroView setTitleIndex:(_lastInt +1) badgeHide:YES];
            }
        }
    }
}

#pragma mark 显示指定标题的红点提示图标
-(void)setShowBadgeIndex:(NSInteger)showBadgeIndex{
    [self.topScroView setTitleIndex:showBadgeIndex badgeHide:NO];
}

- (void)showUnBadgeIndex:(NSInteger)showBadgeIndex
{
    [self.topScroView setTitleIndex:showBadgeIndex badgeHide:YES];
}

-(void)setBadgeColor:(UIColor *)badgeColor{
    [self.topScroView setTitleBadgeColor:badgeColor];
}

-(void)setTitleBagColor:(UIColor *)titleBagColor{
    [self.topScroView setTitleBagColor:titleBagColor];
}

-(void)setTopBagColor:(UIColor *)topBagColor{
    
    self.topScroView.backgroundColor = topBagColor;
}

- (void)setDefaultIndex:(int)nIndex
{
    [self hanleBlockWith:nIndex];
    [self.topScroView setTitleIndex:nIndex badgeHide:YES];
}

/**重置会默认选择第一个按钮*/
-(void)resetSelectFirstIndex{
    
    [self.topScroView setAnimationTime:0.f];
    [self.bottomScroView setContentOffset:(CGPoint){(0)*_self_W,0} animated:YES];
    [self.topScroView setAnimationTime:0.5f];

}
/**移除全部的红点提示*/
-(void)resetAllBadgePrompt{
    for (int i=1; i!=_titleInteger; i++) {
        [self hanleBlockWith:i];
        [self.topScroView setTitleIndex:i badgeHide:YES];
    }
}

/**是否显示顶部的分割线*/
-(void)setTopLineViewHide:(BOOL)value{
    
    self.topScroView.topLineView.hidden = value;
}


@end



