# ZoeRuntimeDemo
[![](https://img.shields.io/badge/Title-ZoeRuntime-FF7F00.svg)](https://github.com/zzzzzzzzzzzzzoe)
[![](https://img.shields.io/badge/author-zoe-000000.svg)](https://github.com/zzzzzzzzzzzzzoe)

## 什么是Runtime
- RunTime简称运行时。OC就是运行时机制，也就是在运行时候的一些机制，其中最主要的是消息机制。
- 对于OC的函数，属于动态调用过程，在编译的时候并不能决定真正调用哪个函数，只有在真正运行的时候才会根据函数的名称找到对应的函数来调用。

## Runtime用处
### 为了快速学习Runtime，本例子列举了七个Runtime常用方法。还有一个比较实用的手动实现kvo的例子，后面会放上来。
- 控制变量
- 分类属性添加
- 方法添加
- 已方法里添加其他功能
- 方法实现的替换和拦截
- 归档解档
- 字典模型转换
### 方法解析
- 获取属性列表
objc_property_t *propertyList = class_copyPropertyList([self class], &count);
 for (unsigned int i=0; i<count; i++) {
     const char *propertyName = property_getName(propertyList[i]);
     NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
 }
![](https://github.com/zzzzzzzzzzzzzoe/ZoeRuntimeDemo/blob/master/gifFile/runtime.gif)
