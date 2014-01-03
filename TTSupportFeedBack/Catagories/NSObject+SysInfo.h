//
//  NSObject+SysInfo.h
//  SupportSystem
//
//  Created by Kevin A. Hoogheem on 1/2/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IOS7 ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define IOS_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//KEVIN - Retina Detection
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@interface NSObject (SysInfo)

-(NSString*)appName;
-(NSString*)appVersion;
-(NSString*)appBuild;
-(NSString*)deviceModel;
-(NSString*)osVersionString;
-(float)osVersionFloat;
- (NSString *)platformString;
- (NSString *)radioAccessName;

@end