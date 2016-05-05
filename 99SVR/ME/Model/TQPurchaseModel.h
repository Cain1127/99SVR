

/**购买私人订制的model*/


#import <Foundation/Foundation.h>
//#import "HttpMessage.pb.h"

@interface TQPurchaseModel : NSObject

/**teamName*/
@property (nonatomic , copy) NSString *teamName;
/**levelid*/
@property (nonatomic , copy) NSString *levelid;
/**levelname*/
@property (nonatomic , copy) NSString *levelname;
/**description*/
@property (nonatomic , copy) NSString *descriptionStr;
/**buytime*/
@property (nonatomic , copy) NSString *buytime;
/**expirtiontime*/
@property (nonatomic , copy) NSString *expirtiontime;
/**buyprice 买的价格*/
@property (nonatomic , copy) NSString *buyprice;
/**updateprice 更新的价格*/
@property (nonatomic , copy) NSString *updateprice;
/**isopen 0 对应的等级 表示没有购买vip 1表示已购买*/
@property (nonatomic , copy) NSString *isopen;
/**是否是vip 只要是有购买过就是vip*/
@property (nonatomic , copy) NSString *vipValue;
/**实际要购买的vip的价格*/
@property (nonatomic , copy) NSString *actualPrice;
/**战队头像*/
@property (nonatomic , copy) NSString *teamIcon;
/**限制购买的数量*/
@property (nonatomic , copy) NSString *maxnum;
#pragma mark 购买私人订制的
/**股票首页*/
- (id)initWithPrivateServiceLevelData:(void *)pData;

@end
