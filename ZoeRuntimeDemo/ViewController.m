//
//  ViewController.m
//  ZoeRuntimeDemo
//
//  Created by mac on 2016/12/3.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import <objc/runtime.h>
#import "NSObject+Category.h"
#import "BookShop.h"


#define kScreen_Bounds [UIScreen mainScreen].bounds
#define kScreen_Height [UIScreen mainScreen].bounds.size.height
#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScaleFrom_iPhone5_Desgin(_X_) (_X_ * (kScreen_Width/320))
#define NAV_HEIGHT 64.0f

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView ;

@property (nonatomic,strong) NSArray * tableDataArray;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (NSArray *)tableDataArray{
    if (!_tableDataArray) {
        _tableDataArray =  [[NSArray alloc]initWithObjects:@"控制变量",@"分类添加属性",@"方法添加",@"方法添加其他功能",@"方法实现的拦截替换",@"归档解档",@"字典转模型",nil];
    }
    return _tableDataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAV_HEIGHT, kScreen_Width, kScreen_Height - NAV_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:240.0/255.0 alpha:1];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = kScaleFrom_iPhone5_Desgin(35);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        
    }
    return  _tableView;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark runtime 

/*
 控制变量
 */
-(void)funcOne{
    Book * book = [[Book alloc]init];
    book.status = @"new book";
    NSLog(@"---------- %@ -----------",book.status);
    unsigned int count = 0;
    Ivar * ivar = class_copyIvarList([book class], &count);
    for (int i = 0;i < count;i++){
        Ivar var = ivar[i];
        NSString * varName = [NSString stringWithUTF8String:ivar_getName(var)];
        if ([@"_status" isEqualToString:varName]) {
            object_setIvar(book, var, @"old book");
            break;
        }
        
    }
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"book" message:book.status delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@"..", nil];
    [alert show];
    
    
}

/*
 给分类添加属性  "NSObject+Category.h"
 由于继承关系 都会被添加一个属性
 */

-(void)funcTwo{
    NSObject * object = [[NSObject alloc]init];
    object.ppap = @"i hava a pen";
    Book * book = [[Book alloc]init];
    book.ppap = @"i hava a apple";
    NSObject * ppap = [[NSObject alloc]init];
    ppap.ppap = @"applepen";
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"ppap" message:[NSString stringWithFormat:@"%@  %@  %@",object.ppap , book.ppap , ppap.ppap] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@"..", nil];
    [alert show];
    
}

/*
 动态方法添加
 */
-(void)funcThree{
    Book * book = [[Book alloc]init];
    class_addMethod([book class], @selector(readBook), class_getMethodImplementation([self class], @selector(read)), method_getTypeEncoding(class_getInstanceMethod([self class], @selector(read))));
    if ([book respondsToSelector:@selector(readBook)]) {
        [book performSelector:@selector(readBook)];
    }else{
        NSLog(@"i don't read this book");
    }
    
}
-(void)read{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"book" message:@"i love this book" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:@"..", nil];
    [alert show];

}

/*
 方法添加其他功能  在方法已经有实现的情况下，可以延伸到方法拦截，方法交换。都能用这种思想去实现。
 */
-(void)funcFour{
    Book * book = [[Book alloc]init];
    [book buy];
}

/*
 方法实现的拦截替换。 在方法未有实现的时候或者想重新写一个实现的时候可以用此。
 */
-(void)funcFive{
    Book * book = [[Book alloc]init];
    Method newMethod = class_getInstanceMethod([self class], @selector(author));
    class_replaceMethod([book class], @selector(author), method_getImplementation(newMethod),method_getTypeEncoding(newMethod));
    [book author];
}
-(void)author{
    NSLog(@"i'm zoe.this book's author is zoe");
    
}

/*
 实现自动归解档
 */
-(void)funcSix{
    Book * book = [[Book alloc]init];;
    book.name = @"好书";
    book.price = @"18.5元";
    NSString *document  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [document stringByAppendingString:@"/book.txt"];
    //模型写入文件
    [NSKeyedArchiver archiveRootObject:book toFile:filePath];
    //读取
    Book * mybook =  [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    NSLog(@"-------%@------",mybook);
    
    
}

/*
 字典转模型
 */
-(void)funcSeven{
    NSDictionary * shopkeeperDic = @{@"name":@"zoe"};
    NSDictionary * dic = @{
                           @"name":@"zoe的书店",
                           @"shopkeeper":shopkeeperDic,
                           @"books":@[@{@"name":@"c语言",@"price":@"15.2元"},@{@"name":@"java语言",@"price":@"25.2元"},@{@"name":@"c#语言",@"price":@"12.2元"}
                                          ]
                           };
    BookShop * bookShop = [BookShop objectWithDict:dic];
    NSLog(@"--%@--,--%@--,--%@--,--%@--",bookShop,bookShop.name,bookShop.shopkeeper.name,bookShop.books[0]);
    
}
#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.tableDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tabelCell" ];
    }
    cell.textLabel.text = [self.tableDataArray objectAtIndex:indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: [self funcOne]; // 控制变量
            break;
        case 1: [self funcTwo]; //分类添加属性
            break;
        case 2 : [self funcThree]; //添加方法
            break;
        case 3 : [self funcFour];// 方法添加其他功能
            break;
        case 4 : [self funcFive];// 方法实现的拦截替换
            break;
        case 5 : [self funcSix];// 归解档
            break;
        default:  [self funcSeven];// 字典转换
            break;
    }
    

}


@end
