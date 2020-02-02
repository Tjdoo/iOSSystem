//
//  Monitor.m
//  NSObject
//
//  Created by CYKJ on 2019/12/24.
//  Copyright © 2019 D. All rights reserved.


#import "Monitor.h"
#import <mach/mach.h>
#import <sys/time.h>
#import <sys/sysctl.h>
#import <sys/types.h>
#import <mach/processor_info.h>


@interface Monitor ()
{
    processor_info_array_t cpuInfo, prevCpuInfo;
    mach_msg_type_number_t numCpuInfo, numPrevCpuInfo;
    unsigned numCPUs;
    NSTimer * updateTimer;
    NSLock * CPUUsageLock;
}
@property (nonatomic, assign) NSTimeInterval  timeInterval;
@end


@implementation Monitor

static Monitor * __instance__ = nil;
+ (instancetype)sharedInstance
{
    return [[[self class] alloc] init];
}

- (instancetype)init
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance__ = [super init];
    });
    
    return __instance__;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance__ = [super allocWithZone:zone];
    });
    return __instance__;
}

- (void)startMonitorWithTimeInterval:(NSTimeInterval)timeInterval
{
    if (timeInterval <= 0) {
        timeInterval = 1.0;
    }
    self.timeInterval = timeInterval;
    
    NSString *filePath = [Monitor cpu_memoryLogPath];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
    [fileHandler seekToEndOfFile];
    NSString *startLog = @"******************************开始统计cpu 和内存************************\n";
    [fileHandler writeData:[startLog dataUsingEncoding:NSUTF8StringEncoding]];
    [self saveMonitorLog];
}

- (void)saveMonitorLog
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        float cpuUsage = [Monitor cpuUsage];
        float memoryUsage = [Monitor memoryUsage];
        
        struct tm* timeNow = [Monitor getCurTime];
        NSString *monitorLog = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d.%ld | cpu 使用率:%.2f ----内存使用:%f\n",
                                timeNow->tm_year,
                                timeNow->tm_mon,
                                timeNow->tm_mday,
                                timeNow->tm_hour,
                                timeNow->tm_min,
                                timeNow->tm_sec,
                                timeNow->tm_gmtoff,
                                cpuUsage,
                                memoryUsage];
        NSLog(@"%@", monitorLog);
        NSString *filePath = [Monitor cpu_memoryLogPath];
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [fileHandler seekToEndOfFile];
        [fileHandler writeData:[monitorLog dataUsingEncoding:NSUTF8StringEncoding]];
        [self saveMonitorLog];
    });
}

+ (NSString *)cpu_memoryLogPath
{
    struct tm* timeNow = [self getCurTime];
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *nFilePath = [path objectAtIndex:0];
    nFilePath = [nFilePath stringByAppendingPathComponent:@"CPUMemoryUsage"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:nFilePath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:nFilePath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    NSString *fileName = [NSString stringWithFormat:@"%d_%d_%d_CPU_Memory_Usage.log",timeNow->tm_year,timeNow->tm_mon,timeNow->tm_mday];
    nFilePath = [nFilePath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:nFilePath]) {
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:nFilePath contents:nil attributes:nil];
        NSLog(@"%d",result);
    }
    return nFilePath;
}

+ (struct tm*)getCurTime
{
    //时间格式
    struct timeval ticks;
    gettimeofday(&ticks, nil);
    time_t now;
    struct tm* timeNow;
    time(&now);
    timeNow = localtime(&now);
    timeNow->tm_gmtoff = ticks.tv_usec/1000;  //毫秒
    
    timeNow->tm_year += 1900;    //tm中的tm_year是从1900至今数
    timeNow->tm_mon  += 1;       //tm_mon范围是0-11
    
    return timeNow;
}


+ (float)cpuUsage
{
    float cpu = cpu_usage();
    return cpu;
}

+ (float)memoryUsage
{
    vm_size_t memory = memory_usage();
    return memory / 1000.0 /1000.0;
}


vm_size_t memory_usage(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

float cpu_usage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}


#pragma mark - =======================================

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    int mib[2U] = { CTL_HW, HW_NCPU };
    size_t sizeOfNumCPUs = sizeof(numCPUs);
    int status = sysctl(mib, 2U, &numCPUs, &sizeOfNumCPUs, NULL, 0U);
    if(status)
        numCPUs = 1;
    
    CPUUsageLock = [[NSLock alloc] init];
    
    updateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                   target:self
                                                 selector:@selector(updateInfo:)
                                                 userInfo:nil
                                                  repeats:YES];
}

- (void)updateInfo:(NSTimer *)timer
{
    natural_t numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(),
                                            PROCESSOR_CPU_LOAD_INFO,
                                            &numCPUsU,
                                            &cpuInfo,
                                            &numCpuInfo);
    if(err == KERN_SUCCESS) {
        [CPUUsageLock lock];
        
        for(unsigned i = 0U; i < numCPUs; ++i) {
            float inUse, total;
            if(prevCpuInfo) {
                inUse = (
                         (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                         + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                         );
                total = inUse + (cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - prevCpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                inUse = cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                total = inUse + cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            NSLog(@"Core: %u Usage: %f",i,inUse / total);
        }
        [CPUUsageLock unlock];
        
        if(prevCpuInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * numPrevCpuInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)prevCpuInfo, prevCpuInfoSize);
        }
        
        prevCpuInfo = cpuInfo;
        numPrevCpuInfo = numCpuInfo;
        
        cpuInfo = NULL;
        numCpuInfo = 0U;
    }
    else {
        NSLog(@"Error!");
    }
}

@end
