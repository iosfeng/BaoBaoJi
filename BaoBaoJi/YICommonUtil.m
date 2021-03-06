//
//  YICommonUtil.m
//  Dobby
//
//  Created by efeng on 15/7/7.
//  Copyright (c) 2015年 weiboyi. All rights reserved.
//

#import "YICommonUtil.h"

@implementation YICommonUtil


+ (void)copyStringToPasteboard:(NSString *)copiedString {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:copiedString];
}

+ (NSString *)appName {
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    return appName;
}

+ (void)suspendAppAndExit {
    //home button press programmatically
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    //wait 2 seconds while app is going background
    [NSThread sleepForTimeInterval:2.0];
    //exit app when app is in background
    exit(0);
}

+ (BOOL)isRegisteredRemoteNotification {
    UIApplication *application = [UIApplication sharedApplication];
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        return [application isRegisteredForRemoteNotifications];
    } else {
        return application.enabledRemoteNotificationTypes != UIRemoteNotificationTypeNone;
    }
}

+ (NSString *)appVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}

+ (NSString *)unixTimestamp {    
    NSDate *date = [NSDate date];
    NSTimeInterval timestamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%li",(long)timestamp];
}

+ (void)toScorePageOfAppStore {
    
    //    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",kAppId];
    
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"app id"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)toHomePageOfAppStore {
    
    //    NSString *str2 = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@", @"911260002"];
    
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",@"kAppId"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
	NSDate *fromDate;
	NSDate *toDate;
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	[calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
				 interval:NULL forDate:fromDateTime];
	[calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
				 interval:NULL forDate:toDateTime];
	
	NSDateComponents *difference = [calendar components:NSCalendarUnitDay
											   fromDate:fromDate toDate:toDate options:0];
	
	return [difference day];
}
@end
