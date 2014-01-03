//
//  NSObject+SysInfo.m
//  SupportSystem
//
//  Created by Kevin A. Hoogheem on 1/2/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "NSObject+SysInfo.h"
#include <sys/sysctl.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>

@implementation NSObject (SysInfo)

-(NSString*)appName
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}
-(NSString*)appVersion
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}
-(NSString*)appBuild
{
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}
-(NSString*)deviceModel
{
    return [UIDevice currentDevice].model;
}
-(NSString*)osVersionString
{
    return [UIDevice currentDevice].systemVersion;
}
-(float)osVersionFloat
{
    return [[UIDevice currentDevice].systemVersion floatValue];
}

- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = @(machine);
    free(machine);
    return platform;
}

- (NSString *)platformString
{
    NSString *platform = [self platform];
	
	//iPhones
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (Global)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (Global)";
	
	//iPods
    if ([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
	
	//iPads
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4 (Global)";
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air (Cellular)";
	
	//iPad Mini
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini (Global)";
	if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini Retina (Cellular)";
	
	
    if ([platform isEqualToString:@"i386"]) return @"iOS Simulator";
    if ([platform isEqualToString:@"x86_64"]) return @"iOS Simulator";
	
    return platform;
}

// Core Telephony
- (NSString *)carrierName {
    CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *crtCarrierName = tni.subscriberCellularProvider.carrierName;
    
#if !__has_feature(objc_arc)
    [tni release];
#endif
    return crtCarrierName;
}

- (NSString *)radioAccessName {
	CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    
    NSString *radioAccessName = tni.currentRadioAccessTechnology;
    
#if !__has_feature(objc_arc)
    [tni release];
#endif
    
    return radioAccessName;
}

@end
