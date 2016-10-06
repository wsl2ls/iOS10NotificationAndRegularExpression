//
//  NotificationViewController.m
//  WSLNotificationViewController
//
//  Created by 王双龙 on 16/10/6.
//  Copyright © 2016年 http://www.jianshu.com/users/e15d1f644bea. All rights reserved.
//

#import "NotificationViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <UserNotificationsUI/UserNotificationsUI.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@property IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)didReceiveNotification:(UNNotification *)notification {
    self.label.text = notification.request.content.body;
    UNNotificationAttachment * att = (UNNotificationAttachment *)notification.request.content.attachments.firstObject;
    _imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:att.URL]];
}

@end
