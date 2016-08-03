//
//  NSNull+LKExtension.m
//  LuoKiOS
//
//  Created by lkshine on 16/7/27.
//  Copyright © 2016年 lkshine. All rights reserved.
//

#import "NSNull+LKExtension.h"
#import <objc/runtime.h>


@implementation NSNull (LKExtension)

+ (void)load
{
    @autoreleasepool {
        [self __cjr_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(methodSignatureForSelector:) replacementSel:@selector(__cjr_methodSignatureForSelector:)];
        [self __cjr_swizzleInstanceMethodWithClass:[NSNull class] originalSel:@selector(forwardInvocation:) replacementSel:@selector(__cjr_forwardInvocation:)];
    }
}

//methodSignatureForSelector: 返回 nil ，Runtime 则会发出 -

- (NSMethodSignature *)__cjr_methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    
    if (signature != nil)
        return signature;
    
    for (NSObject *object in LKNullObject)
    {
        signature = [object methodSignatureForSelector:selector];
        
        if (!signature)
            continue;
        
        if (strcmp(signature.methodReturnType, "@") == 0)
        {
            signature = [[NSNull null] methodSignatureForSelector:@selector(__cjr_nil)];
        }
        
        return signature;
    }
    
    
    return [self __cjr_methodSignatureForSelector:selector];
}

- (void)__cjr_forwardInvocation:(NSInvocation *)anInvocation
{
    if (strcmp(anInvocation.methodSignature.methodReturnType, "@") == 0)
    {
        anInvocation.selector = @selector(__cjr_nil);
        [anInvocation invokeWithTarget:self];
        return;
    }
    
    for (NSObject *object in LKNullObject)
    {
        if ([object respondsToSelector:anInvocation.selector])
        {
            [anInvocation invokeWithTarget:object];
            return;
        }
    }
    
    [self __cjr_forwardInvocation:anInvocation];
}

- (id)__cjr_nil
{
    return nil;
}

+ (void)__cjr_swizzleInstanceMethodWithClass:(Class)clazz originalSel:(SEL)original replacementSel:(SEL)replacement
{
    Method a = class_getInstanceMethod(clazz, original);
    Method b = class_getInstanceMethod(clazz, replacement);
    if (class_addMethod(clazz, original, method_getImplementation(b), method_getTypeEncoding(b)))
    {
        class_replaceMethod(clazz, replacement, method_getImplementation(a), method_getTypeEncoding(a));
    }
    else
    {
        method_exchangeImplementations(a, b);
    }
}


@end


