//
//  CLMethodCrashHelper.m
//  KVODemo
//
//  Created by Apple on 2018/10/16.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "CLMethodCrashHelper.h"
#import <objc/runtime.h>

@interface CLMethodCrashHelper ()

@property (nonatomic, assign) SEL selector;

@end

@implementation CLMethodCrashHelper

- (instancetype)initWithRecognizedSelector:(SEL)selector{
    if (self = [super init]) {
        _selector = selector;
        NSString *selectorString = NSStringFromSelector(_selector);
        SEL sel = sel_registerName([selectorString UTF8String]);
        __weak typeof(self) weakSelf = self;
        IMP imp = imp_implementationWithBlock(^(id a){
            NSLog(@"NSObject+CLSafeMethod---在类:%@中 未实现该方法:%@",NSStringFromClass([self class]),NSStringFromSelector(weakSelf.selector));
        });
        class_addMethod([self class], sel, imp, "v@:@");
    }
    return self;
}

/////重写forwardInvocation:的同时也要重写methodSignatureForSelector:方法，否则会抛出异常。
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
//}
//
/////对于调用没用实现的方法时。由于找不到该方法，而进入消息转发流程。重写消息转发的最后一个步骤，给出提示。不让其闪退。
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//    NSLog(@"NSObject+CLSafeMethod---在类:%@中 未实现该方法:%@",NSStringFromClass([anInvocation.target class]),NSStringFromSelector(anInvocation.selector));
//}




@end
