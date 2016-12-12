//
//  Book.m
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "Book.h"
#import <objc/runtime.h>
@implementation Book

-(void)buy {
    NSLog(@"i want buy this book");
}

-(void)author{
    NSLog(@"i write this book");
}

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Method oldMethod = class_getInstanceMethod([self class], @selector(buy));
        
        Method newMethod = class_getInstanceMethod([self class], @selector(newBuy));
        
        method_exchangeImplementations(oldMethod, newMethod);
        
    });

}

-(void)newBuy{
    NSLog(@"i like this book");
    [self newBuy];
}

@end
