//
//  ViewController.m
//  Predicate
//
//  Created by CYKJ on 2019/8/31.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import "Person.h"
#import "Doctor.h"


@interface ViewController ()

@property (nonatomic, strong) NSMutableArray<Person *> * persons;
@property (nonatomic, strong) NSMutableArray<Doctor *> * doctors;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self isMobileNumber:@"15180168516"];
    [self evaluateObject];
    [self filterPerson];
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
            * 手机号码
            * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
            * 联通：130,131,132,152,155,156,185,186
            * 电信：133,1349,153,180,189
          */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
           * 中国移动：China Mobile
           * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
        */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
            * 中国联通：China Unicom
            * 130,131,132,152,155,156,185,186
           */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
            * 中国电信：China Telecom
           * 133,1349,153,180,189
           */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
            * 大陆地区固话及小灵通
            * 区号：010,020,021,022,023,024,025,027,028,029
            * 号码：七位或八位
            */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        if([regextestcm evaluateWithObject:mobileNum] == YES) {
            NSLog(@"中国移动");
        } else if([regextestct evaluateWithObject:mobileNum] == YES) {
            NSLog(@"联通");
        } else if ([regextestcu evaluateWithObject:mobileNum] == YES) {
            NSLog(@"电信");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)evaluateObject
{
    NSString * string = @"1234";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF = '1234'"];
    
    // 验证对象是否符合条件。底层调用了 [xx compare:] 方法
    if ([predicate evaluateWithObject:string]) {
        NSLog(@"Success!");
    }
    else {
        NSLog(@"Fail!");
    }
    
    // if ([predicate evaluateWithObject:Array])  // 传入数组，报错 Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSArrayI compare:]: unrecognized selector sent to instance 0x600000234c00'
    
    // BETWEEN（范围运算符）
    NSNumber * number = @(1234);
    predicate = [NSPredicate predicateWithFormat:@"SELF BETWEEN {1000, 2000}"];
    
    if ([predicate evaluateWithObject:number]) {
        NSLog(@"Success!");
    }
    else {
        NSLog(@"Fail!");
    }
    
    // MATCHES（正则表达式）
    NSString * phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString * phoneNumber = @"15180168516";
    predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    if ([predicate evaluateWithObject:phoneNumber]) {
        NSLog(@"%@ 是电话号码!", phoneNumber);
    }
    else {
        NSLog(@"%@ 不是电话号码!", phoneNumber);
    }
}

- (void)filterPerson
{
    NSLog(@"%@", self.persons);
    
    /*
                比较运算符：=、==、>=（=>）、<=（=<）、<、>、!=（<>）、BETWEEN
                逻辑运算符：AND（&&）、OR（||）、NOT（!）
                字符串比较运算符：BEGINSWITH、ENDSWITH、CONTAINS、LIKE、MATCHES
                集合运算符：ANY、SOME、ALL、NONE、IN
                直接量：FALSE（NO）、TRUE（YES）、NULL（NIL）、SELF（self）、"string"（'string'）、数组、数值、十六进制数（0x）、八进制（0o）、二进制（0b）
         */
    
    
    
    // 年龄 < 25
    NSString * predicateString = @"age < 25";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:predicateString];

    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    // 25 < 年龄 < 30
    predicateString = @"age > 25 && age < 30";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);

    
    
    // **********   CONTAINS（字符串中包含子串）。姓名包含 'Tom" || 包含 "Jay"
    predicateString = @"SELF.name CONTAINS[c] 'Tom' || SELF.name CONTAINS[c] 'Jay'";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    
    // **********   BEGINSWITH（字符串以什么开始）。姓名以 "Tom" 开头、姓名中包含 '0'
    predicateString = @"name BEGINSWITH 'Tom' && name contains '0'";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    // 姓名以 "Tom" 开头、姓名中包含 '0'、年龄在 20 ~ 30
    predicateString = [NSString stringWithFormat:@"name BEGINSWITH 'Tom' && name contains '0'  && age BETWEEN {%d,%d} ", 20, 30]; // 等价于 && age >= 20 && age <= 30
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    
    // **********   ENDSWITH（字符串以什么结尾）。姓名以 '1' 结尾
    predicateString = @"name ENDSWITH '1'";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    
    // **********   LIKE（全字符匹配，注意：不是包含的意思。* 代表任意多个字符，? 代表一个字符）
    predicateString = @"SELF.name LIKE '*Tom*'";  // 这种情况等价于 contains 'Tom'
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    predicateString = @"SELF.name LIKE '?Tom'"; // 'T?m'
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    
    // **********   ANY
    NSArray * arr = @[ self.persons ];  // 需要是数组嵌套的结构
    predicateString = @"ANY name LIKE 'Tom*2'";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [arr filteredArrayUsingPredicate:predicate]);
    
    
    // **********   IN（是 {} 内容中的任一个）。因为 name 是动态的，所以下面的 name 不会等于 'Tom' 或者 'Jay'
    //predicateString = @"self.name IN {'Tom','Jay'}";
    predicateString = @"self.name IN {'Tom','Jay'} || self.age IN{25,30}";
    predicate = [NSPredicate predicateWithFormat:predicateString];
    
    NSLog(@"%@ = %@", predicateString, [self.persons filteredArrayUsingPredicate:predicate]);
    
    
    // **********   %K、%@、&Value
    NSString * key = @"name";
    NSString * value = @"0";
    predicate = [NSPredicate predicateWithFormat:@"%K CONTAINS %@ && age > $VALUE", key, value];
    predicate = [predicate predicateWithSubstitutionVariables:@{ @"VALUE" : @(25) }];
    
    NSLog(@"%@ = %@", predicate.predicateFormat, [self.persons filteredArrayUsingPredicate:predicate]);
}





#pragma mark - GET

- (NSMutableArray<Person *> *)persons
{
    if (_persons == nil) {
        _persons = [NSMutableArray arrayWithCapacity:30];
        
        for (NSInteger i = 0; i < 10; i++) {
            Person * p = [[Person alloc] init];
            p.name = [NSString stringWithFormat:@"Tom%04d", arc4random_uniform(10000)];
            p.age  = arc4random_uniform(20) + 15;
            [_persons addObject:p];
        }
        for (NSInteger i = 0; i < 10; i++) {
            Person * p = [[Person alloc] init];
            p.name = [NSString stringWithFormat:@"Jay%04d", arc4random_uniform(10000)];
            p.age  = arc4random_uniform(20) + 15;
            [_persons addObject:p];
        }
        for (NSInteger i = 0; i < 10; i++) {
            Person * p = [[Person alloc] init];
            p.name = [NSString stringWithFormat:@"Luy%04d", arc4random_uniform(10000)];
            p.age  = arc4random_uniform(20) + 15;
            [_persons addObject:p];
        }
    }
    return _persons;
}

- (NSMutableArray<Doctor *> *)doctors
{
    if (_doctors == nil) {
        // 读取 json 文件
        NSData * data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"doctor"
                                                                                       ofType:@"json"]];
        NSArray * array = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
        _doctors = [NSMutableArray<Doctor *> arrayWithArray:array];
    }
    return _doctors;
}

@end
