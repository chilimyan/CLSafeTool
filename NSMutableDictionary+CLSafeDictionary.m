//
//  NSMutableDictionary+CLSafeDictionary.m
//  KVODemo
//
//  Created by Apple on 2018/10/15.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import "NSMutableDictionary+CLSafeDictionary.h"
#import "NSObject+CLSwizzling.h"
#import <objc/runtime.h>

static char const *classNameDicM = "__NSDictionaryM";

@implementation NSMutableDictionary (CLSafeDictionary)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class classM = objc_getClass(classNameDicM);
      
        cl_swizzleMethod_tool(classM, @selector(setObject:forKey:), @selector(cl_setObjectM:forKey:));
        cl_swizzleMethod_tool(classM, @selector(removeObjectForKey:), @selector(cl_removeObjectForKeyM:));
    });
}

- (void)cl_setObjectM:(id)anObject forKey:(id<NSCopying>)aKey{
    if (!anObject || !aKey) {
        @try {
            return [self cl_setObjectM:anObject forKey:aKey];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        [self cl_setObjectM:anObject forKey:aKey];
    }
}

- (void)cl_removeObjectForKeyM:(id)aKey{
    if (!aKey) {
        @try {
            [self cl_removeObjectForKeyM:aKey];
        }
        @catch (NSException *exception) {
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
        }
        @finally {}
    }else{
        [self cl_removeObjectForKeyM:aKey];
    }
}


@end
