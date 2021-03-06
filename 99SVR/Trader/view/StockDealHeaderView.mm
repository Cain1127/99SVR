

#define typeLab_h ValueWithTheIPhoneModelString(@"60,60,60,60")//日收益 月收益 总收益的lab高度
#define typeLab_Top_h (((self.height*2/3) - typeLab_h)/2.0)//日收益 月收益 总收益的lab 距离顶部的高度
#define stockNam_fot ValueWithTheIPhoneModelString(@"15,15,15,15")//股票的名称大小
#define totalTitLabFont ValueWithTheIPhoneModelString(@"15,15,15,15")//总收益的大小
#define totalNumLabFont ValueWithTheIPhoneModelString(@"20,20,25,25")//总收益,收益排行，与收益，日收益数字的大小

#import "StockDealHeaderView.h"
#import "StockMacro.h"
#import "ShareFunction.h"
@interface StockDealHeaderView ()

@end

@implementation StockDealHeaderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    //日收益
    self.dayLabView = [[StockLabel alloc]initWithFrame:(CGRect){0,static_cast<CGFloat>(typeLab_Top_h),static_cast<CGFloat>(self.width/3.0),typeLab_h}];
    self.dayLabView.isShowLine = YES;
    [self addSubview:self.dayLabView];
    
    //月收益
    self.monLabView = [[StockLabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(self.dayLabView.frame),CGRectGetMinY(self.dayLabView.frame),static_cast<CGFloat>(self.width/3.0),typeLab_h}];
    self.monLabView.isShowLine = YES;
    [self addSubview:self.monLabView];

    //总收益
    self.rankLabView = [[StockLabel alloc]initWithFrame:(CGRect){CGRectGetMaxX(self.monLabView.frame),CGRectGetMinY(self.dayLabView.frame),static_cast<CGFloat>(self.width/3.0),typeLab_h}];
    [self addSubview:self.rankLabView];
    
    //中间的线
    self.midLineView = [[UIView alloc]init];
    self.midLineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
;
    [self addSubview:self.midLineView];
    [self.midLineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(@(self.height*2/3));
        make.left.equalTo(@10);
        make.right.equalTo(@(-10));
        make.height.equalTo(@(LineView_Height));
    }];
    
    //标题
    self.stockLab = [[UILabel alloc]init];
    self.stockLab.textAlignment = NSTextAlignmentCenter;
    self.stockLab.font = [UIFont systemFontOfSize:stockNam_fot];
    self.stockLab.layer.cornerRadius = 5.0;
    self.stockLab.layer.borderColor = [UIColor whiteColor].CGColor;
    self.stockLab.layer.borderWidth = 0.5f;
    self.stockLab.layer.masksToBounds = YES;
    self.stockLab.textColor = [UIColor whiteColor];
    [self addSubview:self.stockLab];
    
    
    //总收益文字
    self.totalNumLab = [[UILabel alloc]init];
    self.totalNumLab.textAlignment = NSTextAlignmentRight;
    self.totalNumLab.textColor = [UIColor whiteColor];
    self.totalNumLab.font = [UIFont systemFontOfSize:totalNumLabFont];
    [self addSubview:self.totalNumLab];
    
    //总收益的数字
    self.totalLab = [[UILabel alloc]init];
    self.totalLab.textAlignment = NSTextAlignmentRight;
    self.totalLab.textColor = [UIColor whiteColor];
    self.totalLab.font = [UIFont systemFontOfSize:totalTitLabFont];
    [self addSubview:self.totalLab];
}

-(void)setHeaderViewWithDataModel:(StockDealModel *)model{

    
    self.dayLabView.titLab.text = @"日收益";
    self.monLabView.titLab.text = @"月收益";
    self.rankLabView.titLab.text = @"收益排行";
    
    self.dayLabView.numLab.text = model.dayprofit;
    self.monLabView.numLab.text = model.monthprofit;
    NSString *rankStr = [NSString stringWithFormat:@"跑赢%@",model.winrate];
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:rankStr];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:10.0]
     
                          range:NSMakeRange(0, 2)];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:totalNumLabFont]
     
                          range:NSMakeRange(2, rankStr.length-2)];
    
    self.rankLabView.numLab.attributedText = AttributedStr;
    
    
    
    
    NSString *stockStr = model.focus;
    self.stockLab.text = stockStr;
    
    CGSize stockLabSize = [ShareFunction calculationOfTheText:self.stockLab.text withFont:stockNam_fot withMaxSize:(CGSize){200,CGFLOAT_MAX}];
    
    CGFloat bottom = ((self.height*1/3)-stockLabSize.height-10)/2.0;
    
    [self.stockLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@(stockLabSize.width + 10));
        make.height.equalTo(@(stockLabSize.height + 10));
        make.bottom.equalTo(@(-bottom));
    }];
    
    NSString *totalStr = [NSString stringWithFormat:@"%@ 总收益",model.totalprofit];
    NSMutableAttributedString *totalAttributedStr = [[NSMutableAttributedString alloc]initWithString:totalStr];
    
    [totalAttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:totalNumLabFont]
     
                          range:NSMakeRange(0, totalAttributedStr.length-3)];
    
    [totalAttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:totalTitLabFont]
     
                          range:NSMakeRange(totalAttributedStr.length-3, 3)];
    
    self.totalLab.attributedText = totalAttributedStr;

    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(totalNumLabFont));
        make.left.equalTo(self.stockLab.mas_right).offset(10);
        make.right.equalTo(@(-10));
        make.bottom.equalTo(self.stockLab.mas_bottom);
    }];
}
@end



#pragma mark 股票的label ========================================================
@implementation StockLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI{

    self.titLab = [[UILabel alloc]init];
    self.titLab.font = [UIFont systemFontOfSize:15];
    self.titLab.textAlignment = NSTextAlignmentCenter;
    self.titLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    [self addSubview:self.titLab];
    
    
    self.numLab = [[UILabel alloc]init];
    self.numLab.font = [UIFont systemFontOfSize:totalNumLabFont];
    self.numLab.textColor = [UIColor whiteColor];
    self.numLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.numLab];

    
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@20);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.bottom.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@(totalNumLabFont));
    }];
}

-(void)setIsShowLine:(BOOL)isShowLine{
    
    if (isShowLine) {
        
        UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){self.width-1,0,1,self.height}];
        [self addSubview:lineView];
        lineView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    }
}




@end