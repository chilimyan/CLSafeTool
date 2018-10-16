//
//  NSDictionary+CLSafeDictionary.m
//  KVODemo
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSDictionary+CLSafeDictionary.h"
#import "NSObject+CLSwizzling.h"
#import <objc/runtime.h>

static char const *classNamePlaceHold = "__NSPlaceholderDictionary";

@implementation NSDictionary (CLSafeDictionary)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class classPlaceHold = objc_getClass(classNamePlaceHold);
        cl_swizzleMethod_tool(classPlaceHold, @selector(initWithObjects:forKeys:count:), @selector(initWithObjects_cl:forKeys:count:));
    });
}

- (instancetype)initWithObjects_cl:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt{
    if (cnt == 0) {
        return [self initWithObjects_cl:objects forKeys:keys count:cnt];
    }
    if (!objects || !keys) {
        @try {
            return [self initWithObjects_cl:objects forKeys:keys count:cnt];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }
    // 指向objects初始位置
    // 指向keys初始位置
    NSUInteger keyCnt = 0;
    NSUInteger valueCnt = 0;
    // 遍历找到为key nil的位置
    for (   ; valueCnt < cnt; valueCnt ++, objects++) {
        if (*objects == 0)
        {
            @try {
                return [self initWithObjects_cl:objects forKeys:keys count:cnt];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
                return nil;
            }
            @finally {}
            break;
        }
    }
    // 遍历找到为key nil的位置
    for (   ; keyCnt < cnt; keyCnt ++, keys++) {
        if (*keys == 0) // 遍历找到为key nil的位置
        {
            @try {
                return [self initWithObjects_cl:objects forKeys:keys count:cnt];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
                return nil;
            }
            @finally {}
            break;
        }
    }
    // 找到最小值
    //cnt 不能越界
    NSUInteger minCnt = MIN(keyCnt, valueCnt);
    NSInteger newCnt = MIN(minCnt, cnt);
    
    for (int i = 0; i<valueCnt; i++) {
        objects--;
    }
    for (int i = 0; i<keyCnt; i++) {
        keys--;
    }
    
    return [self initWithObjects_cl:objects forKeys:keys count:newCnt];
}

@end
