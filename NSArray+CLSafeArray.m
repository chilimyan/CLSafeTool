//
//  NSArray+CLSafeArray.m
//  KVODemo
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSArray+CLSafeArray.h"
#import "NSObject+CLSwizzling.h"
#import <objc/runtime.h>

static char const *className0 = "__NSArray0";
static char const *classNameSingle = "__NSSingleObjectArrayI";
static char const *classNameI = "__NSArrayI";
static char const *classNamePlaceHold = "__NSPlaceholderArray";

@implementation NSArray (CLSafeArray)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class0 = objc_getClass(className0);
        Class classSingle = objc_getClass(classNameSingle);
        Class classI = objc_getClass(classNameI);
        Class classPlaceHold = objc_getClass(classNamePlaceHold);
        swizzleMethod(class0, @selector(objectAtIndex:), @selector(cl_objectAtIndex0:));
        swizzleMethod(classSingle, @selector(objectAtIndex:), @selector(cl_objectAtIndexSingle:));
        swizzleMethod(classI, @selector(objectAtIndex:), @selector(cl_objectAtIndexI:));
        swizzleMethod(classPlaceHold, @selector(objectAtIndex:), @selector(cl_objectAtIndexPlaceHold:));
        swizzleMethod(classPlaceHold, @selector(initWithObjects:count:), @selector(initWithObjects_cl:count:));
    });
}

- (instancetype)initWithObjects_cl:(id *)objects count:(NSUInteger)count{
    //判断数组初始化是否有nil对象，如果有则抛出异常
    for (int i = 0; i < count; i ++) {
        if (objects[i] == nil) {
            @try {
                return [self initWithObjects_cl:objects count:count];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
                return nil;
            }
            @finally {}
        }
    }
    return [self initWithObjects_cl:objects count:count];
}

- (id)cl_objectAtIndexPlaceHold:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (![self judgeArrayIndex:index]) {
        @try {
            return [self cl_objectAtIndexPlaceHold:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }else{
        //没有越界
        return [self cl_objectAtIndexPlaceHold:index];
    }
}

- (id)cl_objectAtIndex0:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (![self judgeArrayIndex:index]) {
        @try {
            return [self cl_objectAtIndex0:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }else{
        //没有越界
        return [self cl_objectAtIndex0:index];
    }
}

- (id)cl_objectAtIndexSingle:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (![self judgeArrayIndex:index]) {
        @try {
            return [self cl_objectAtIndexSingle:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }else{
        //没有越界
        return [self cl_objectAtIndexSingle:index];
    }
}

- (id)cl_objectAtIndexI:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (![self judgeArrayIndex:index]) {
        @try {
            return [self cl_objectAtIndexI:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }else{
        //没有越界
        return [self cl_objectAtIndexI:index];
    }
}

- (BOOL)judgeArrayIndex:(NSUInteger)index{
    if (!self.count || self.count == 0) {
        return NO;
    }else if (self.count - 1 < index){
        return NO;
    }
    return YES;
}

@end
