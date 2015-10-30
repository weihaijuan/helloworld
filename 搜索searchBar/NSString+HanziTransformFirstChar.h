//
//  NSString+HanziTransformFirstChar.h
//  我的Dangdang
//
//  Created by weihaijuan on 15/8/13.
//  Copyright (c) 2015年 魏海娟. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HanziTransformFirstChar)

+(NSString *)firstCharFromHanzi:(NSString *)hanzi;

+(NSString *)spellFromHanzi:(NSString *)hanzi;

@end
