

/**购买私人订制的model*/


#import <Foundation/Foundation.h>
//#import "HttpMessage.pb.h"

@interface TQPurchaseModel : NSObject

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
/**buyprice*/
@property (nonatomic , copy) NSString *buyprice;
/**updateprice*/
@property (nonatomic , copy) NSString *updateprice;
/**isopen*/
@property (nonatomic , copy) NSString *isopen;

#pragma mark 购买私人订制的
/**股票首页*/

@end
