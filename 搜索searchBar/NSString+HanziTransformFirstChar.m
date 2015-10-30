//
//  NSString+HanziTransformFirstChar.m
//  我的Dangdang
//
//  Created by weihaijuan on 15/8/13.
//  Copyright (c) 2015年 魏海娟. All rights reserved.
//

#import "NSString+HanziTransformFirstChar.h"

@implementation NSString (HanziTransformFirstChar)

+(NSString *)firstCharFromHanzi:(NSString *)hanzi
{
    NSMutableString *tmpString = [NSMutableString stringWithString:hanzi];
    
    //kCFStringTransformMandarinLatin转换为带音标的拼音
    CFStringTransform((CFMutableStringRef)tmpString,NULL, kCFStringTransformMandarinLatin,NO);
    //kCFStringTransformStripDiacritics去掉拼音中的音标
    CFStringTransform((CFMutableStringRef)tmpString,NULL, kCFStringTransformStripDiacritics,NO);
    return [[[NSString stringWithString:tmpString] substringToIndex:1] uppercaseString];
}

+(NSString *)spellFromHanzi:(NSString *)hanzi
{
    NSMutableString *tmpString = [NSMutableString stringWithString:hanzi];
    
    //kCFStringTransformMandarinLatin转换为带音标的拼音
    CFStringTransform((CFMutableStringRef)tmpString,NULL, kCFStringTransformMandarinLatin,NO);
    //kCFStringTransformStripDiacritics去掉拼音中的音标
    CFStringTransform((CFMutableStringRef)tmpString,NULL, kCFStringTransformStripDiacritics,NO);
    return [NSString stringWithString:tmpString];
}
@end
