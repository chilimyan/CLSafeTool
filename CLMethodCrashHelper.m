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

- (instancetype)initWithRecognizedSelector:(SEL)selector class:(Class)class{
    if (self = [super init]) {
        _selector = selector;
        NSString *selectorString = NSStringFromSelector(_selector);
        SEL sel = sel_registerName([selectorString UTF8String]);
        __weak typeof(self) weakSelf = self;
        //随便写一个实现
        IMP imp = imp_implementationWithBlock(^(id param){
            NSLog(@"ERROR==========NSObject+CLSafeMethod---在类:%@中 未实现该方法:%@",NSStringFromClass(class),NSStringFromSelector(weakSelf.selector));
        });
        ///为这个没实现的方法动态添加到这个类里面。
        class_addMethod([self class], sel, imp, "v@:@");
    }
    return self;
}

@end
