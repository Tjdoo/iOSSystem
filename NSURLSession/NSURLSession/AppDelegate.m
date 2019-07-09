//
//  AppDelegate.m
//  NSURLSession
//
//  Created by D on 2019/5/7.
//  Copyright © 2019 D. All rights reserved.


#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger duration;
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    [self testTimer];
    
    NSLog(@"%s",__func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.timer invalidate];
    self.timer = nil;
    self.duration = 0;
    
    NSLog(@"%s", __func__);
}

- (void)testTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerRun)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)timerRun
{
    _duration += 1;
    NSLog(@"%zd", _duration);
}

/**
  *  @brief   AppDelegate 后台下载回调，需要处理下载完成后的数据
 *  @discussion   该代理方法使用场景分析：

                1、不实现该代理方法，只有手动将后台的 App 进入前台后会调用成功的回调 URLSession:downloadTask:didFinishDownloadingToURL:，处理相关的数据。 -》部分情况下异常
 
                     缺点和问题：
                        ①、如果下载完成后，不进入前台或者手动杀死进程，则丢失下载数据；
                        ②、等待下载的任务无法开始下载；
                        ③、下载完成后，在后台无法使用本地通知。
 
                2、实现该方法，不执行 completionHandler，某一下载任务完成后唤醒 App，继续其它下载任务 -》异常
                3、实现该方法，执行 completionHandler，某一下载任务完成后唤醒 App，继续其它下载任务 -》一切正常
  *
  *  @param   completionHandler   大概意思是：回调 callbacks，只要 session 创建将会开始接收到。回调 callbacks 没有对你的应用程序进行任何的处理，一旦完成处理 callbacks，你应该调用 completionHandler。
  */
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler
{
    NSLog(@"%s", __func__);
    
    completionHandler();
}


- (void)applicationWillTerminate:(UIApplication *)application {}

@end
