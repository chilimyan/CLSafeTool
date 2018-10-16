//
//  NSObject+CLSafeMethod.m
//  KVODemo
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSObject+CLSafeMethod.h"
#import "NSObject+CLSwizzling.h"
#import <objc/runtime.h>
#import "CLMethodCrashHelper.h"

@implementation NSObject (CLSafeMethod)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cl_swizzleMethod_tool([self class], @selector(forwardingTargetForSelector:), @selector(cl_forwardingTargetForSelector:));
    });
}

- (id)cl_forwardingTargetForSelector:(SEL)aSelector{
    if ([self respondsToSelector:aSelector]) {
        return [self cl_forwardingTargetForSelector:aSelector];
    }else{
        return [[CLMethodCrashHelper alloc] initWithRecognizedSelector:aSelector];
    }
}

@end
