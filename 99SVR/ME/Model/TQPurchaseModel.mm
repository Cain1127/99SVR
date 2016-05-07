
#import "StockMacro.h"
#import "TQPurchaseModel.h"
#include "HttpMessage.pb.h"

@implementation TQPurchaseModel

- (id)initWithPrivateServiceLevelData:(void *)pData
{
    self = [super init];
    if (self) {
        PrivateServiceLevelDescription *profit = (PrivateServiceLevelDescription *)pData;
        _levelname = StrTransformCToUTF8(profit->levelname().c_str());
        _descriptionStr = StrTransformCToUTF8(profit->description().c_str());
        _buytime = StrTransformCToUTF8(profit->buytime().c_str());
        _expirtiontime = StrTransformCToUTF8(profit->expirtiontime().c_str());
        
        _vipLevelExpirtiontime = _expirtiontime;
        if (_expirtiontime.length==0) {
            _expirtiontime = @"终身有效";
            _vipLevelExpirtiontime = @"/终身";
        }
        
        _levelid = IntTransformIntToStr(profit->levelid());
        _isopen = IntTransformIntToStr(profit->isopen());
        _buyprice = [NSString stringWithFormat:@"%.2f 玖玖币",(profit->buyprice())];
        _updateprice = [NSString stringWithFormat:@"%.2f 玖玖币",(profit->updateprice())];
        _actualPrice = @"";
        _maxnum = IntTransformIntToStr(profit->maxnum());

    }

    return self;
}

@end
