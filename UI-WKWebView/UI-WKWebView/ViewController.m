//
//  ViewController.m
//  UI-WKWebView
//
//  Created by CYKJ on 2019/7/8.
//  Copyright © 2019年 D. All rights reserved.


#import "ViewController.h"
#import <WebKit/WKWebsiteDataRecord.h>
#import <WebKit/WKWebsiteDataStore.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]);
}

- (IBAction)removeWebCache:(id)sender
{
    if (@available(iOS 9.0, *)) {
        NSSet * websiteDataTypes = [NSSet setWithArray:@[ WKWebsiteDataTypeDiskCache,
                                                          //WKWebsiteDataTypeOfflineWebApplication
                                                          WKWebsiteDataTypeMemoryCache,
                                                          //WKWebsiteDataTypeLocal
                                                          WKWebsiteDataTypeCookies,
                                                          //WKWebsiteDataTypeSessionStorage,
                                                          //WKWebsiteDataTypeIndexedDBDatabases,
                                                          //WKWebsiteDataTypeWebSQLDatabases
                                                       ]];
        
        // All kinds of data
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes
                                                   modifiedSince:dateFrom
                                               completionHandler:^{
            
        }];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
    else {
        // 先删除 cookie
        NSHTTPCookie * cookie;
        NSHTTPCookieStorage * storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (cookie in [storage cookies]) {
            [storage deleteCookie:cookie];
        }
        
        NSString * libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * bundleId  =  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
        NSString *webKitFolderInCaches = [NSString stringWithFormat:@"%@/Caches/%@/WebKit", libraryDir, bundleId];
        NSString * webKitFolderInCachesfs = [NSString stringWithFormat:@"%@/Caches/%@/fsCachedData", libraryDir, bundleId];
        NSError * error;
        /* iOS8.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
        [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
        /* iOS7.0 WebView Cache的存放路径 */
        [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
        NSString *cookiesFolderPath = [libraryDir stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&error];
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

@end
