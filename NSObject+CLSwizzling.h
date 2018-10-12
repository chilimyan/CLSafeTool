//
//  NSObject+CLSwizzling.h
//  KVODemo
//
//  Created by Apple on 2018/10/12.
//  Copyright © 2018年 chilim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CLSwizzling)

void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector);

@end
