//
//  ViewController.m
//  正则表达式
//
//  Created by 王双龙 on 16/10/3.
//  Copyright © 2016年 王双龙. All rights reserved.
//

#import "ViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //正则表达式
    NSString * str = @"153249516@163.com && 12345@qq.com";
    BOOL isEmail =  [self validateEmail:str];
    [self validateTest:@"< herf articleingovapp=2016/9/6/111111 123456articleingovapp=2016/09/26/234123 >"];
    

}

//新建通知内容并发送通知
- (IBAction)postNoti:(id)sender {
    
    UNUserNotificationCenter * center = [UNUserNotificationCenter currentNotificationCenter];
   //校验是否拥有权限，用户可能会关闭通知权限
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSUInteger status = [settings authorizationStatus];
        NSLog(@"当前的权限是？ %ld",status);
        if (status == 1) {
            return ;
        }
    }];
    
    //第二步：新建通知内容对象
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"iOS10通知";//标题
    content.subtitle = @"且行且珍惜_iOS";//子标题
    content.body = @"欢迎关注我的Github：https://github.com/wslcmk，和简书：http://www.jianshu.com/users/e15d1f644bea";//消息的主题
    content.badge = @0;
    //UNNotificationSound *sound = [UNNotificationSound soundNamed:@"See You Again"];
    //content.sound = sound;
    //默认声音
    content.sound = [UNNotificationSound defaultSound];

    //content.launchImageName = @"wang";
    //将categroy赋值到通知内容上
    content.categoryIdentifier = @"Categroy";

    
    //指明添加使用的附件,可以是图片(5MB)、Video(50MB)、音乐(5MB)
    NSError * error;
    NSString * path1 = [[NSBundle mainBundle] pathForResource:@"wang" ofType:@"jpeg"];
    NSString * path2 = [[NSBundle mainBundle] pathForResource:@"See You Again" ofType:@"m4r"];
    UNNotificationAttachment * att1 = [UNNotificationAttachment attachmentWithIdentifier:@"imageAtt" URL:[NSURL fileURLWithPath:path1] options:nil error:&error];
    UNNotificationAttachment * att2 = [UNNotificationAttachment attachmentWithIdentifier:@"audioAtt" URL:[NSURL fileURLWithPath:path2] options:@{} error:&error];
    //虽然是数组，但是添加多个只能显示第一个
    content.attachments = @[att1];
    
    //添加交互
    //点击可以显示文本输入框
    UNTextInputNotificationAction *action1 = [UNTextInputNotificationAction actionWithIdentifier:@"replyAction" title:@"文字回复" options:UNNotificationActionOptionNone];
    //点击进入应用
    UNNotificationAction *action2 = [UNNotificationAction actionWithIdentifier:@"enterAction" title:@"进入应用" options:UNNotificationActionOptionForeground];
    //点击取消，没有任何操作
    UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"cancelAction" title:@"取消" options:UNNotificationActionOptionDestructive];
    //通过UNNotificationCategory对象将这几个action行为添加到通知里去
    UNNotificationCategory *categroy = [UNNotificationCategory categoryWithIdentifier:@"Categroy" actions:@[action1,action2,action3] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
    //设置通知类别
    [center setNotificationCategories:[NSSet setWithObject:categroy]];
    
    
    //第三步：通知触发机制。（重复提醒，时间间隔要大于60s）
    /*
    触发器分为三种：
     
    UNPushNotificaitonTrigger 远程推送服务的Trigger，由系统创建
     
    UNTimeIntervalNotificationTrigger 时间触发器，可以设置多长时间以后触发，是否重复。如果设置重复，重复时长要大于60s
    
    UNCalendarNotificationTrigger 日期触发器，可以设置某一日期触发。例如，提醒我每天早上七点起床：
    
    UNLocationNotificationTrigger 位置触发器，用于到某一范围之后，触发通知。通过CLRegion设定具体范围。
     
     */
    
    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    /*
    //每周一早上8：00触发  UNCalendarNotificationTrigger
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 2;
    components.hour = 8;
    components.minute = 0;
    UNCalendarNotificationTrigger *trigger2 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    //到达某个位置触发通知，通过CLRegion设定具体范围
    CLRegion *region = [[CLRegion alloc] init];
    UNLocationNotificationTrigger *trigger3 = [UNLocationNotificationTrigger triggerWithRegion:region repeats:NO];
    */
    
    //第四步：创建UNNotificationRequest通知请求对象
    NSString *requertIdentifier = @"requertIdentifier";
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requertIdentifier content:content trigger:trigger1];
    
    //第五步：将通知加到通知中心
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"Error:%@",error);
        
    }];
    
}

//通知更新与删除
- (void)updateAndDelete{
    
    UNUserNotificationCenter * center  = [UNUserNotificationCenter currentNotificationCenter];
    
    //更新通过之前的addNotificationRequest:方法，在id不变的情况下重新添加，就可以刷新原有的通知啦。
    NSString *requestIdentifier = @"requertIdentifier"; //这里就是被更新的那个requestIdentifier
    UNMutableNotificationContent *newContent = [[UNMutableNotificationContent alloc] init];
    UNTimeIntervalNotificationTrigger *newTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:newContent trigger:newTrigger];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    }];
    
    //删除
    [center removePendingNotificationRequestsWithIdentifiers:@[requestIdentifier]];
    
}

//验证邮箱
- (BOOL)validateEmail:(NSString *)email{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    //谓词主要用来判定是否符合格式
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //符合邮箱格式返回YES
    return [emailTest evaluateWithObject:email];
    
}
//筛选出字符串
- (void)validateTest:(NSString *)text{

    NSString *testRegex = @"articleingovapp=\\d{4}/\\d{0,2}/\\d{0,2}/\\d{6}";
    
    //匹配字符串
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:testRegex options:0 error:nil];
    
    //返回匹配结果
    NSArray *matcheResults = [regularExpression matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    NSLog(@"%ld",(unsigned long)matcheResults.count);
    
    //遍历取出符合格式要求的字符串
    for (NSTextCheckingResult *matcheResult in matcheResults) {
        
        NSLog(@"%@",[text substringWithRange:matcheResult.range]);
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
