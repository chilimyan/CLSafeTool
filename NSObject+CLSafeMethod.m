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
    ///如果已实现该方法则直接正常返回，否则将方法转交给CLMethodCrashHelper处理
    if ([self respondsToSelector:aSelector]) {
        return [self cl_forwardingTargetForSelector:aSelector];
    }else{
        ///注意这里要先判断是否是系统类的方法。如果是系统的类则正常返回，不做处理。
        NSBundle *mainB = [NSBundle bundleForClass:[self class]];
        if (mainB == [NSBundle mainBundle]) {
            NSLog(@"自定义的类");
            return [[CLMethodCrashHelper alloc] initWithRecognizedSelector:aSelector class:[self class]];
        }else
        {
            NSLog(@"系统的类");
            return [self cl_forwardingTargetForSelector:aSelector];
        }
    }
}

@end
