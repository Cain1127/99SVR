//
//  proto_err.h
//  99SVR
//
//  Created by xia zhonglin  on 4/22/16.
//  Copyright © 2016 xia zhonglin . All rights reserved.
//

#ifndef proto_err_h
#define proto_err_h

enum
{
    PERR_CONNECT_ERROR = 0x100,
    PERR_IO_ERROR,
    PERR_JSON_PARSE_ERROR = 0x200
};

#endif /* proto_err_h */
