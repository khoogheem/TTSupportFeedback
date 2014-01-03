//
//  TTSupportFeedBack.h
//
//  Created by Kevin A. Hoogheem on 12/16/13.
//  Copyright (c) 2013. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, FeedBackOptions) {
    kFeedBackRateApp			= 1 << 0,
//    kFeedBackEmailSupport		= 1 << 1, //Email is always added
    kFeedbackSupportGuide		= 1 << 1,
    kFeedBackSocial				= 1 << 2,
};

typedef NS_ENUM(NSInteger, SupportStyle){
    kSupportStyleHappy		= 1,
    kSupportStyleConfused,
	kSupportStyleUnHappy,
};

@interface TTSupportFeedBack : UITableViewController

//Default is to use the AppName as the Handle.  No need to put @ before username
@property (nonatomic, strong) NSString *twitterUsername;
@property (nonatomic, strong) NSString *weiboUsername;

// Message to send when Tweeting/Facebook/Weibo
@property (nonatomic, strong) NSString *socialMsg;

+ (NSString *)defaultHappyHeader;
+ (NSString *)defaultConfusedHeader;
+ (NSString *)defaultUnhappyHeader;

- (instancetype)initWithSupportStyle:(SupportStyle)style;
- (instancetype)initWithSupportStyle:(SupportStyle)style tintColor:(UIColor *)tintColor;
- (instancetype)initWithFeedBackOptions:(FeedBackOptions)options headerMsg:(NSString *)header;
- (instancetype)initWithFeedBackOptions:(FeedBackOptions)options headerMsg:(NSString *)header tintColor:(UIColor *)tintColor;

@end
