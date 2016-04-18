

#define titLab_fot ValueWithTheIPhoneModelString(@"15,17,18,20") //操盘的名称
#define totalTitLab_fot ValueWithTheIPhoneModelString(@"17,18,20,25") //总收益
#define dayLab_fot ValueWithTheIPhoneModelString(@"15,17,18,20") //日收益
#define monLab_fot ValueWithTheIPhoneModelString(@"15,17,18,20") //月收益
#define rankLab_fot ValueWithTheIPhoneModelString(@"15,17,18,20") //收益排行


#import "StockDealHeaderView.h"
#import "MacroHeader.h"
@implementation StockDealHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initUI];
        [self setAutoLayout];
        
    }
    return self;
}

-(void)initUI{
    //标题
    self.titLab = [[UILabel alloc]init];
    self.titLab.font = [UIFont systemFontOfSize:titLab_fot];
    [self addSubview:self.titLab];
    
    //总收益
    self.totalLab = [[UILabel alloc]init];
    self.totalLab.font = [UIFont systemFontOfSize:totalTitLab_fot];
    [self addSubview:self.totalLab];
    
    //日收益
    self.dayLab = [[UILabel alloc]init];
    self.dayLab.numberOfLines = 2;
    self.dayLab.font = [UIFont systemFontOfSize:dayLab_fot];
    [self addSubview:self.dayLab];
    
    //月收益
    self.monLab = [[UILabel alloc]init];
    self.monLab.numberOfLines = 2;
    self.monLab.font = [UIFont systemFontOfSize:monLab_fot];
    [self addSubview:self.monLab];
    
    //收益排行
    self.rankLab = [[UILabel alloc]init];
    self.rankLab.numberOfLines = 2;
    self.rankLab.font = [UIFont systemFontOfSize:rankLab_fot];
    [self addSubview:self.rankLab];
    
    self.rankLab.text = @"收益排行\n跑赢1.13%组合";
    self.monLab.text = @"月收益\n1.13";
    self.dayLab.text = @"日收益\n1.13";
    self.totalLab.text = @"11.13总收益";
    self.titLab.text = @"专注专线";
    
    self.rankLab.backgroundColor = [UIColor whiteColor];
    self.monLab.backgroundColor = [UIColor whiteColor];
    self.dayLab.backgroundColor = [UIColor whiteColor];
    self.totalLab.backgroundColor = [UIColor whiteColor];
    self.titLab.backgroundColor = [UIColor whiteColor];

}

-(void)setAutoLayout{
    
    //标题
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(@(ValueWithTheIPhoneModelString(@"10,10,10,10")));
        make.height.equalTo(@(titLab_fot));
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
    }];
    
    //总收益
    [self.totalLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titLab.mas_bottom).offset(ValueWithTheIPhoneModelString(@"10,10,10,10"));
        make.left.equalTo(self.titLab.mas_left).offset(0);
        make.height.equalTo(@(totalTitLab_fot));
        make.right.equalTo(@(ValueWithTheIPhoneModelString(@"-10,-10,-10,-10")));
    }];
    
    //日收益
    [self.dayLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLab.mas_bottom).offset(10);
        make.left.equalTo(self.titLab.mas_left).offset(0);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"80,80,80,80")));
        make.height.equalTo(@(2*dayLab_fot+10));
    }];
    
    //月收益
    [self.monLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLab.mas_bottom).offset(10);
        make.left.equalTo(self.dayLab.mas_right).offset(30);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"80,80,80,80")));
        make.height.equalTo(@(2*monLab_fot+10));
    }];
    
    //收益排行
    [self.rankLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.totalLab.mas_bottom).offset(10);
        make.left.equalTo(self.monLab.mas_right).offset(30);
        make.width.equalTo(@(ValueWithTheIPhoneModelString(@"80,80,80,80")));
        make.height.equalTo(@(2*rankLab_fot+10));
    }];
}

@end
