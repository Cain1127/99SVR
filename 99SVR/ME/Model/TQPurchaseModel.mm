
#import "StockMacro.h"
#import "TQPurchaseModel.h"
#include "HttpMessage.pb.h"

@implementation TQPurchaseModel

- (id)initWithPrivateServiceLevelData:(void *)pData
{
    self = [super init];
    PrivateServiceLevelDescription *profit = (PrivateServiceLevelDescription *)pData;
    _levelname = StrTransformCToUTF8(profit->levelname().c_str());
    _descriptionStr = StrTransformCToUTF8(profit->description().c_str());
    _buytime = StrTransformCToUTF8(profit->buytime().c_str());
    _expirtiontime = StrTransformCToUTF8(profit->expirtiontime().c_str());
    _levelid = IntTransformIntToStr(profit->levelid());
    _isopen = IntTransformIntToStr(profit->isopen());
    _buyprice = [NSString stringWithFormat:@"%f",profit->buyprice()];
    _updateprice = [NSString stringWithFormat:@"%f",profit->updateprice()];
    
    return self;
}

@end
