//
//  chineseInclude.m
//  铛铛Pro
//
//  Created by Soarfeel on 15/8/20.
//  Copyright (c) 2015年 ForMyHeart. All rights reserved.
//

#import "chineseInclude.h"

@implementation chineseInclude
+(BOOL)isIncludeChineseInStr:(NSString *)str
{
    for (int i=0; i<str.length; i++) {
        unichar ch=[str characterAtIndex:i];
        if (0x4E00<ch&&ch<0x9FA5) {
            return true;
        }
    }
    return false;
}

@end
