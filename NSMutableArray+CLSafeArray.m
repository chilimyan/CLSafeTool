//
//  NSMutableArray+CLSafeArray.m
//  KVODemo
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSMutableArray+CLSafeArray.h"
#import "NSObject+CLSwizzling.h"
#import <objc/runtime.h>

static char const *classNameM = "__NSArrayM";

@implementation NSMutableArray (CLSafeArray)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class classM = objc_getClass(classNameM);
        
        cl_swizzleMethod_tool(classM, @selector(objectAtIndex:), @selector(cl_objectAtIndex:));
        cl_swizzleMethod_tool(classM, @selector(insertObject:atIndex:), @selector(cl_insertObject:atIndex:));
        cl_swizzleMethod_tool(classM, @selector(setObject:atIndex:), @selector(cl_setObject:atIndex:));
        cl_swizzleMethod_tool(classM, @selector(setObject:atIndexedSubscript:), @selector(cl_setObject:atIndexedSubscript:));
        cl_swizzleMethod_tool(classM, @selector(removeObjectsInRange:), @selector(cl_removeObjectsInRange:));
        cl_swizzleMethod_tool(classM, @selector(replaceObjectAtIndex:withObject:), @selector(cl_replaceObjectAtIndex:withObject:));
    });
}

- (void)cl_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    //判断数组是否越界，如果越界则抛出异常
    if (!self.count || self.count == 0 || index >= self.count) {
        @try {
            [self cl_replaceObjectAtIndex:index withObject:anObject];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        //插入对象不能为nil
        if (!anObject) {
            @try {
                [self cl_replaceObjectAtIndex:index withObject:anObject];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
            }
            @finally {}
        }else{
            [self cl_replaceObjectAtIndex:index withObject:anObject];
        }
    }
}

- (void)cl_removeObjectsInRange:(NSRange)range{
    //判断数组是否越界，如果越界则抛出异常
    if (range.location > self.count || (range.location + range.length) > self.count) {
        @try {
            [self cl_removeObjectsInRange:range];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        [self cl_removeObjectsInRange:range];
    }
}

- (void)cl_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx{
    //判断数组是否越界，如果越界则抛出异常
    if (!self.count || idx > self.count) {
        @try {
            [self cl_setObject:obj atIndexedSubscript:idx];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        //数组没用越界，判断插入对象是否为nil，为nil则抛出异常
        if (!obj) {
            @try {
                [self cl_setObject:obj atIndexedSubscript:idx];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
            }
            @finally {}
        }else{
            [self cl_setObject:obj atIndexedSubscript:idx];
        }
    }
}

- (void)cl_setObject:(id)anObject atIndex:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (!self.count || index > self.count) {
        @try {
            [self cl_setObject:anObject atIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        //数组没用越界，判断插入对象是否为nil，为nil则抛出异常
        if (!anObject) {
            @try {
                [self cl_setObject:anObject atIndex:index];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
            }
            @finally {}
        }else{
            [self cl_setObject:anObject atIndex:index];
        }
    }
}

- (void)cl_insertObject:(id)anObject atIndex:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (!self.count || index > self.count) {
        @try {
            [self cl_insertObject:anObject atIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        //数组没用越界，判断插入对象是否为nil，为nil则抛出异常
        if (!anObject) {
            @try {
                [self cl_insertObject:anObject atIndex:index];
            }
            @catch (NSException *exception) {
                NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
                NSLog(@"%@", [exception callStackSymbols]);
            }
            @finally {}
        }else{
            [self cl_insertObject:anObject atIndex:index];
        }
    }
}

- (id)cl_objectAtIndex:(NSUInteger)index{
    //判断数组是否越界，如果越界则抛出异常
    if (![self judgeArrayIndex:index]) {
        @try {
            return [self cl_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }else{
        //没有越界
        return [self cl_objectAtIndex:index];
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
