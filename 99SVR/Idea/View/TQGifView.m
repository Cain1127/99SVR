//
//  TQGifView.m
//  99SVR
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 xia zhonglin . All rights reserved.
//

#import "TQGifView.h"
#import "TQGifConllectionCell.h"
static CGFloat const margin = 10;
static NSInteger const cols = 4;
#define cellWH ((kScreenWidth - (cols - 1) * margin) / cols)
@interface TQGifView() <UICollectionViewDataSource, UICollectionViewDelegate>
/** <#desc#> */
@property (nonatomic ,weak)UICollectionView *collectionView;

@end
@implementation TQGifView
static NSString * const GifConllectionCell = @"GifConllectionCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        // 创建UICollectionView流水布局
        UICollectionViewFlowLayout *layout = [self setupCollectionLayout];
        
        // 创建UICollectionView,UICollectionView默认为黑色
        [self setupCollectionView:layout];
        
        [self creatView];
    }
    
    return self;
}

    // 创建UICollectionView,UICollectionView默认为黑色
    - (void)setupCollectionView:(UICollectionViewFlowLayout *)layout
    {
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 30, self.width, 300) collectionViewLayout:layout];
        collectionView.center = self.center;
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:collectionView];
        collectionView.backgroundColor = [UIColor blackColor];
        // 设置数据源
        collectionView.dataSource = self;
        // 监听cell点击
        collectionView.delegate = self;
        
        // 注册PhotoCell
        [collectionView registerNib:[UINib nibWithNibName:@"TQGifConllectionCell" bundle:nil] forCellWithReuseIdentifier:GifConllectionCell];
        
        
        
    }

    -(void)creatView {
        
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TQGiftButtomView" owner:nil options:nil] lastObject];
        view.frame = CGRectMake(0, self.height - 40, self.width, 40);
        
        [self addSubview:view];
        
////        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
////        [btn setImage:[UIImage imageNamed:@"chat_s"] forState:UIControlStateNormal];
////        [self addSubview:btn];
////        btn.frame = CGRectMake(self.width - 30, 0, 30, 30);
////        [btn addTarget:self action:@selector(exitCurrentController) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    // 创建UICollectionView流水布局
    - (UICollectionViewFlowLayout *)setupCollectionLayout
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(cellWH, cellWH);;
        // 行间距
        layout.minimumLineSpacing = 30;
        // 设置cell间距,
        layout.minimumInteritemSpacing = margin;
        return layout;
        
        
        
    }
    
#pragma mark - UICollectionViewDataSource
    // 返回cell个数
    - (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
        return 8;
    }
    
    // 返回cell外观
    - (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        TQGifConllectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GifConllectionCell forIndexPath:indexPath];
        
        //    NSString *imageName = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
        //    cell.image = [UIImage imageNamed:imageName];
        cell.backgroundColor = [UIColor orangeColor];
        
        return cell;
    }
        
@end
