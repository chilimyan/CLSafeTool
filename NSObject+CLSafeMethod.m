//
//  NSObject+CLSafeMethod.m
//  KVODemo
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSObject+CLSafeMethod.h"

@implementation NSObject (CLSafeMethod)

///重写forwardInvocation:的同时也要重写methodSignatureForSelector:方法，否则会抛出异常。
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
}

///对于调用没用实现的方法时。由于找不到该方法，而进入消息转发流程。重写消息转发的最后一个步骤，给出提示。不让其闪退。
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    NSLog(@"NSObject+CLSafeMethod---在类:%@中 未实现该方法:%@",NSStringFromClass([anInvocation.target class]),NSStringFromSelector(anInvocation.selector));
}

@end
