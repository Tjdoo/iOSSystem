//
//  TimeStamp.h
//  Date&Time
//
//  Created by CYKJ on 2019/5/21.
//  Copyright © 2019年 D. All rights reserved.


#import <Foundation/Foundation.h>

/**   时间戳。文章：https://www.jianshu.com/p/82475b5a7e19
 
        需求：移动 app 平时向服务端发的所有 request 请求，作为基础数据，所有的 request 都应该携带请求的时间戳等信息。关于时间戳，因为客户端的时间不是很靠谱（用户随时可以自己修改时间），所以原则上，客户端的时间仅仅作为参考。真正涉及 DBA 或是 DB 部门数据统计或计算的时候，必然以 server 端为准。虽然如此，app 还是希望取一个尽量可以准确的时间。

        思路：每次系统重启后会一直记录启动至今的时间称为 upTime。根据 api 获取服务器时间 serverTime 和 upTime 的差值 timerOffset，将这个值保存下来，后续每次发 request 请求的时候，基于 timerOffset 将 upTime 换算为上传的真正时间值即可，然后定时或者按照一定周期和服务端同步，将 timerOffset 进行修正。代码如下：
 
             self.timerOffset = serverTime - upTime;
             NSTimeInterval uploadTime = upTime + self.timerOffset;
 */
@interface TimeStamp : NSObject

- (NSTimeInterval)upTime1;

- (time_t)upTime2;

@end
