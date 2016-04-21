
/**股票交易记录*/

#import "CustomViewController.h"

typedef NS_ENUM(NSInteger,RecordType){
    
    //交易动态
    RecordType_Business,
    //持仓详情
    RecordType_StoreHouse,
};

@interface StockRecordViewController : CustomViewController
/**类型*/
@property (nonatomic , assign) RecordType recordType;

@end
