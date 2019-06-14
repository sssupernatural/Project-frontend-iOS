//
//  TaskStatus.h
//  Tree
//
//  Created by 施威特 on 2018/1/16.
//  Copyright © 2018年 施威特. All rights reserved.
//

#ifndef TaskStatus_h
#define TaskStatus_h

/* Task Status */
#define TaskStatusCreating              11000
#define TaskStatusWaitingAccept         11001
#define TaskStatusWaitingChoose         11002
#define TaskStatusProcessing            11003
#define TaskStatusFulfilled             11004
#define TaskStatusFinished              11005
#define TasKStatusSearchResponserFailed 11006
#define TasKStatusSearchResponserNone   11007
/* Task Status */

/* Task Action Status */
#define TaskActionStatusError                  10000 //错误状态
#define RequesterStatus_WaitingAccept          10001 //[等待响应者中] (取消活动)
#define RequesterStatus_WaitingChoose          10002 //(选择响应者) (取消活动)
#define RequesterStatus_Processing             10003 //[活动进行中] (取消活动)
#define RequesterStatus_Fulfilled              10004 //(评价活动参与者)
#define RequesterStatus_Finished               10005 //[活动已结束]

#define ResponserStatus_WaitingAccept          10006 //[已经响应活动] (取消响应)
#define ResponserStatus_WaitingChoose          10007 //[已经响应活动] (取消响应)

#define ChosenResponserStatus_Processing       10008 //(完成活动) (退出活动)
#define ChosenResponserStatus_Fulfilled        10009 //(评价活动参与者)
#define ChosenResponserStatus_Finished         10010 //[活动已结束]

#define PotentialResponserStatus_WaitingAccept 10011 //(参与活动) (拒绝活动)
/* Task Action Status */




#endif /* TaskStatus_h */
