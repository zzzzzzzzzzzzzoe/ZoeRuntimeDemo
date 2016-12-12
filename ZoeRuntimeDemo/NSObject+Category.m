//
//  NSObject+Category.m
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>

@implementation NSObject(Category)

char key;

- (void)setPpap:(NSString *)ppap{
    objc_setAssociatedObject(self, &key, ppap, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)ppap {
    return objc_getAssociatedObject(self, &key);
}
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"  

- (instancetype)initWithCoder:(NSCoder *)aDecoder  {
   
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
    
    
    return self;
    
}

- (void)encodeWithCoder:(NSCoder *)encoder{
    
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKeyPath:key];
            [encoder encodeObject:value forKey:key];
        }
        free(ivars);

}

+ (instancetype)objectWithDict:(NSDictionary *)dict
{
    id objc = [[self alloc] init];
    
    unsigned int count = 0;
    
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivarList[i];
        NSString *key = [[NSString stringWithUTF8String:ivar_getName(ivar)] substringFromIndex:1];
        id value = dict[key];
        if (nil == value) {
            continue;
        }
        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        if ([value isKindOfClass:[NSDictionary class]] ) {
            if (![type hasPrefix:@"NS"]) {
                type = [type substringWithRange:NSMakeRange(2, type.length - 3)];
                Class modalClass = NSClassFromString(type);
                if (modalClass) {
                    value = [modalClass objectWithDict:value];
                }

            }
           
        }

        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(arrayObjectClassDic)]) {
                id modelSelf = self;
                NSString *type =  [modelSelf arrayObjectClassDic][key];
                Class classModel = NSClassFromString(type);

                NSMutableArray *modelArray = [[NSMutableArray alloc]init];;
                for (NSDictionary *dict in value) {
                    id model =  [classModel objectWithDict:dict];
                    [modelArray addObject:model];
                }
                value = modelArray;
                
            }
        }
            [objc setValue:value forKey:key];

    }
    
    
    return objc;
    
}
@end
