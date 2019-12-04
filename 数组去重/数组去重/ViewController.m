//
//  ViewController.m
//  数组去重
//
//  Created by Tim on 2019/12/4.
//  Copyright © 2019 Tim. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *arr_1;

@property (nonatomic, strong) NSMutableArray *arr_2;

@end

@implementation ViewController

- (NSMutableArray *)arr_1
{
    if(!_arr_1){
        _arr_1 = [NSMutableArray array];
        for (NSInteger i = 0; i < 20000; i++) {
            Person *p = [[Person alloc] init];
            p.name = [NSString stringWithFormat:@"name_%zd", i];
            [_arr_1 addObject:p];
        }
    }
    return _arr_1;
}


- (NSMutableArray *)arr_2
{
    if(!_arr_2){
        _arr_2 = [NSMutableArray array];
        for (NSInteger i = 0; i < 20000; i++) {
            if (i % 2 == 0) {
                Person *p = [[Person alloc] init];
                p.name = [NSString stringWithFormat:@"name_%zd", i];
                [_arr_2 addObject:p];
            }
        }
    }
    return _arr_2;
}


- (void)test1:(NSMutableDictionary *)dict
{
    CFAbsoluteTime startTime =CFAbsoluteTimeGetCurrent();
    [self.arr_1 enumerateObjectsUsingBlock:^(Person *p, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [dict objectForKey:p.name];
        if (name.length > 0) {
            [self.arr_1 removeObject:p];
        }
    }];
    
    CFAbsoluteTime linkTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"字典Block删除元素时长 : %f ms  去重后的数组count = %ld", linkTime *1000.0,self.arr_1.count);
}



- (void)test2
{
    CFAbsoluteTime startTime1 =CFAbsoluteTimeGetCurrent();
    NSMutableArray *newArr1 = [NSMutableArray array];
    for (int i = 0; i<self.arr_1.count; i++) {
        Person *person = self.arr_1[i];
        BOOL hava = NO;
        for (int j = 0; j<self.arr_2.count; j++) {
            Person *person2 = self.arr_2[j];
            if([person.name isEqualToString:person2.name]){
                hava = YES;
            }
        }
        if(!hava){
            [newArr1 addObject:self.arr_1[i]];
        }
    }
    
    CFAbsoluteTime linkTime1 = (CFAbsoluteTimeGetCurrent() - startTime1);
    NSLog(@"双层for循环时长 : %f ms  去重后的数组count = %ld", linkTime1 *1000.0,newArr1.count);
}



- (void)test3:(NSMutableDictionary *)dict
{
    CFAbsoluteTime startTime2 =CFAbsoluteTimeGetCurrent();
    
    NSMutableArray *newArr = [NSMutableArray array];
    [self.arr_1 enumerateObjectsUsingBlock:^(Person *p, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = [dict objectForKey:p.name];
        if (name.length <= 0) {
            [newArr addObject:p];
        }
    }];
    
    CFAbsoluteTime linkTime2 = (CFAbsoluteTimeGetCurrent() - startTime2);
    NSLog(@"字典Block时长 : %f ms  去重后的数组count = %ld", linkTime2 *1000.0,newArr.count);
}





- (void)test4:(NSMutableDictionary *)dict
{
    CFAbsoluteTime startTime2 =CFAbsoluteTimeGetCurrent();
    
    NSMutableArray *newArr = [NSMutableArray array];
    for (int i = 0; i<self.arr_1.count; i++) {
        Person *p = self.arr_1[i];
        NSString *name = [dict objectForKey:p.name];
        if (name.length <= 0) {
            [newArr addObject:p];
        }
    }
    
    CFAbsoluteTime linkTime2 = (CFAbsoluteTimeGetCurrent() - startTime2);
    NSLog(@"字典for循环时长 : %f ms  去重后的数组count = %ld", linkTime2 *1000.0,newArr.count);
}



- (void)test5
{
    CFMutableDictionaryRef myDict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    for (Person *p in self.arr_2) {
        CFDictionarySetValue(myDict, (__bridge void *)p.name, (__bridge void *)p.name);
    }
    
    CFAbsoluteTime startTime3 =CFAbsoluteTimeGetCurrent();
    
    NSMutableArray *newArr2 = [NSMutableArray array];
    [self.arr_1 enumerateObjectsUsingBlock:^(Person *p, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = (__bridge id)CFDictionaryGetValue(myDict, (__bridge void *)p.name);
        if (name.length <= 0) {
            [newArr2 addObject:p];
        }
    }];
    CFAbsoluteTime linkTime3 = (CFAbsoluteTimeGetCurrent() - startTime3);
    NSLog(@"CFMutableDictionaryRef时长 : %f ms  去重后的数组count = %ld", linkTime3 *1000.0,newArr2.count);
}


- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (Person *p in self.arr_2) {
        [dict setObject:p.name forKey:p.name];
    }
    [self test1:dict];
    [self test2];
    [self test3:dict];
    [self test4:dict];
    [self test5];
}

@end
