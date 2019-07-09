//
//  ViewController.m
//  NSURLSession
//
//  Created by D on 2019/5/7.
//  Copyright © 2019 D. All rights reserved.


#import "ViewController.h"

@interface ViewController () <NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession * downloadSession;
@property (nonatomic, strong) NSURLSessionDownloadTask * downloadTask;
@property (nonatomic, strong) NSData * resumeData;

@end


@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 注册 app 活跃的通知监听
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {

          // 当 App 手动退出或者闪退后，重新启动时获取正在下载的 tasks
          NSMutableDictionary * mDict = [self.downloadSession valueForKey:@"tasks"];
          
          [mDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
              
          }];
    }];
    
    // ①、在创建下载 session 时需要一个下载标识，该标识需要在整个系统内保证唯一，所以使用 APP 的 bundleId。
    NSString * bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString * identifier = [NSString stringWithFormat:@"%@.BackgroundSession", bundleId];

    // ②、sessionConfig.allowsCellularAccess 控制是否可以通过蜂窝网络下载
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
    sessionConfig.allowsCellularAccess = YES;
    
    self.downloadSession = [NSURLSession sessionWithConfiguration:sessionConfig
                                                         delegate:self
                                                    delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:@""]];
    
    // 创建下载任务：其实通过 session 创建的任务是 NSURLSessionDownloadTask 的子类 __NSCFBackgroundDownloadTask，是苹果的私有 API。
    self.downloadTask = [self.downloadSession downloadTaskWithRequest:request];
    [self.downloadTask resume];
}


#pragma mark - Touch
/**
  *  @brief   暂停
  */
- (IBAction)suspend:(id)sender
{
    __weak typeof(self) weakSelf = self;
    // downloadTask 有多种办法去暂停，但是选择有 resume 的下载方法，可以更加方便我们管理和多次暂停继续。
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.resumeData = resumeData;
    }];
    
    // ④、取消或者删除下载
//    [self.downloadTask cancel];
}

/**
  *  @brief   开启
  */
- (IBAction)resume:(id)sender
{
    // 通过 resumeData 继续下载
    self.downloadTask = [self.downloadSession downloadTaskWithResumeData:self.resumeData];
    [self.downloadTask resume];
}


#pragma mark - NSURLSessionDelegate
/**
  *  @brief   下载任务开始后，下载文件的进度回调方法。
  *  @param    bytesWritten  某一断点续传过程中已经下载的数据大小
  *  @param    totalBytesWritten   已经下载的文件的大小
  *  @param   totalBytesExpectedToWrite  当前需要下载的文件的大小
  */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

/**
  *  @brief   下载任务继续开始下载时的回调方法
  */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}

/**
  *  @brief   当资源发生重定向时回调的方法。NSURLSession 内部自己处理定向回调
  */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    
}

/**
  *  @brief   当下载任务完成后的代理回调方法。
  *  @param   location  是下载完成后的文件，在沙盒当中存在的路径
  */
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}

/**
  *  @brief    假如在后台下载完成的回调，会触发该回调方法。
  */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    
}

/**
  *  @brief   下载失败后的回调。暂停、停止、失败都会触发。区别是：正常状态下的暂停会回调 resumeData，如果 resumeData 不为空的话我们需要保存该数据，方便下次继续、
  */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{

}

@end
