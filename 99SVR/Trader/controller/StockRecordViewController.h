
/**股票交易记录*/

#import "CustomViewController.h"

typedef NS_ENUM(NSInteger,RecordType){
    
    //交易动态
    RecordType_Business=1,
    //持仓详情
    RecordType_StoreHouse=2,
};

@interface StockRecordViewController : CustomViewController
/**类型*/
@property (nonatomic , assign) RecordType recordType;

/**operateId*/
@property (nonatomic , assign) NSInteger operateId;


@end
