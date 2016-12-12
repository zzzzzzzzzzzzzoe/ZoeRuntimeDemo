//
//  BookShop.h
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/5.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Category.h"
#import "Book.h"
#import "Person.h"

@interface BookShop : NSObject<arrayObjectClassDelegate>
@property (nonatomic,copy) NSString * name;
@property (nonatomic,strong) Person * shopkeeper;
@property (nonatomic,strong) NSArray * books;
@end
