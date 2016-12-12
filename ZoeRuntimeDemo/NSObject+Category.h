//
//  NSObject+Category.h
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol arrayObjectClassDelegate <NSObject>

@optional
// 如模型中有数组，要实现这个协议
+ (NSDictionary *)arrayObjectClassDic;

@end


@interface  NSObject(Category)
@property (nonatomic, copy) NSString * ppap;
+ (instancetype)objectWithDict:(NSDictionary *)dict;
@end
