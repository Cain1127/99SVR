//
//  TextSecretAllModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextSecretAllModel.h"

@implementation TextSecretAllModel

+ (TextSecretAllModel *)createModel:(CMDTextRoomSecretsTotalResp_t*)resp
{
    TextSecretAllModel *model = [[TextSecretAllModel alloc] init];
    model.vcbid = resp->vcbid;
    model.userid = resp->userid;
    model.teacherid = resp->teacherid;
    model.secretsnum = resp->secretsnum;
    model.ownsnum = resp->ownsnum;
    model.bStudent = resp->bStudent;
    return model;
}
@end
