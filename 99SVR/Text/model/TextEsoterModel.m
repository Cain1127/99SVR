//
//  TextEsoterModel.m
//  99SVR
//
//  Created by xia zhonglin  on 3/29/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#import "TextEsoterModel.h"
#import "UserInfo.h"
#import "NSDate+convenience.h"

@implementation TextEsoterModel

+ (TextEsoterModel *)createModel:(CMDTextRoomSecretsListResp_t*)resp buf:(char *)cBuf
{
    TextEsoterModel *model = [[TextEsoterModel alloc] init];
    model.secretsid = resp->secretsid;
    model.messagetime = resp->messagetime;
    model.buyflag = resp->buyflag;
    model.buynums = resp->buynums;
    model.prices = resp->prices;
    model.goodsid = resp->goodsid;
    model.coverlittlelen = resp->coverlittlelen;
    model.titlelen = resp->titlelen;
    model.textlen = resp->textlen;
    
    char cTitle[model.titlelen+1];
    char cText[model.textlen+1];
    char cCover[model.coverlittlelen+1];
    strncpy(cCover,cBuf,model.coverlittlelen);
    strncpy(cTitle,cBuf+model.coverlittlelen,model.titlelen);
    strncpy(cText,cBuf+model.coverlittlelen+model.textlen,model.textlen);
    
    model.cover = [NSString stringWithCString:cCover encoding:GBK_ENCODING];
    model.title = [NSString stringWithCString:cTitle encoding:GBK_ENCODING];
    model.content = [NSString stringWithCString:cText encoding:GBK_ENCODING];
    
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    NSDate *date = [userinfo.fmt dateFromString:NSStringFromInt64(model.messagetime)];
    model.strTime = [NSString stringWithFormat:@"%d:%d",date.hour,date.minute];
    return model;
}

@end
