//
//  Book.h
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/4.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject
@property (nonatomic,copy) NSString * status;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * price;
-(void)buy;
-(void)author;
@end
