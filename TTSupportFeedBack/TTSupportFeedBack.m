//
//  TTSupportFeedBack.m
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

#import "TTSupportFeedBack.h"
#import "NSObject+SysInfo.h"
#import "UIImage+Utils.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "TTSupportFeedBackContactViewController.h"
#import "TTSupportFeedBackObject.h"
#import "Appirater.h"


#define USE_OLD_TABLE_INSETS 0

typedef NS_ENUM(NSInteger, SupportSections){
    kSupportSectionUpper = 0,
    kSupportSectionSocial
};


@interface TTSupportFeedBack () {

}
@property (nonatomic, retain) NSString *headerMsg;
@property (nonatomic, retain) NSString *supportURL;
@property (nonatomic, assign) SupportStyle supportStyle;
@property (nonatomic, assign) NSUInteger sections;
@property (nonatomic, assign) UIColor *tintColor;

//Holds the Cell Items
@property (nonatomic, retain) NSArray *cellItems;
//Array of the Cells
@property (nonatomic, readonly) NSArray *upperCellItems;
@property (nonatomic, readonly) NSArray *socialCellItems;

@end

@implementation TTSupportFeedBack

//Should get your AppID - if it is a nil vaule the Review section will not show in the menu
- (NSString *)getAppID {
	//Best to get this some source outside of the app..  Unless you know before Submitting
	return @"ReplaceMeWithyourAppID";
}

- (void)dealloc {
	self.cellItems = nil;
}

#pragma mark - Init
-(id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
		_sections = 1;
		_supportStyle = 0;  //set style to NOStyle
		self.tableView.scrollEnabled = NO;  //Make so table does not scroll.. we won't have that many options..
		
		if (!IOS7) {
			//Set the Grouped Table Background view to nil
			[self.tableView setBackgroundView:nil];
		}
		//now set the color
		self.tableView.backgroundColor = [UIColor whiteColor];

		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
			self.edgesForExtendedLayout = UIRectEdgeNone;

		//Set USE_OLD_TABLE_INSETS to use old sytle insets pre-7
		if (IOS7 && USE_OLD_TABLE_INSETS){
			if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
				[self.tableView setSeparatorInset:UIEdgeInsetsZero];
			}
		}
		
    }
    return self;
}

- (instancetype)initWithSupportStyle:(SupportStyle)style {
	return [self initWithSupportStyle:style tintColor:nil];
}

- (instancetype)initWithSupportStyle:(SupportStyle)style tintColor:(UIColor *)tintColor{
	self = [self init];
    if(self){
		_supportStyle = style;
		_tintColor = tintColor;
		
		//setup the Header/Sections/Cells per section
		if (style == kSupportStyleHappy) {
			_headerMsg = [TTSupportFeedBack defaultHappyHeader];
			_sections = 2;
			self.cellItems = @[self.upperCellItems, self.socialCellItems];
		}else if (style == kSupportStyleConfused) {
			_headerMsg = [TTSupportFeedBack defaultConfusedHeader];
			self.cellItems = @[self.upperCellItems];
		}else if (style == kSupportStyleUnHappy){
			_headerMsg = [TTSupportFeedBack defaultUnhappyHeader];
			self.cellItems = @[self.upperCellItems];
		}
		
    }
    return self;
}

- (instancetype)initWithFeedBackOptions:(FeedBackOptions)options headerMsg:(NSString *)header {
	return [self initWithFeedBackOptions:options headerMsg:header tintColor:nil];
}

- (instancetype)initWithFeedBackOptions:(FeedBackOptions)options headerMsg:(NSString *)header tintColor:(UIColor *)tintColor {
	
	self = [self init];
    if(self){
		_headerMsg = header;
		_tintColor = tintColor;
		
		NSMutableArray *upper = [[NSMutableArray alloc] init];
		
		if (options & kFeedBackRateApp) {
			[upper addObject:[self reviewCellInfo]];
		}
		if (options & kFeedbackSupportGuide) {
			[upper addObject:[self userGuideCellInfo]];
		}
		[upper addObject:[self contactCellInfo]];
		
		NSMutableArray *social = [[NSMutableArray alloc] init];
		if (options & kFeedBackSocial) {
			_sections = 2;
			[social addObject:[self twitterCellInfo]];
			[social addObject:[self faceBookCellInfo]];
		}
		
		self.cellItems = @[upper, social];
		
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
		
	self.title = NSLocalizedStringFromTable(@"Support", @"TTSupportFeedBack", @"Page Title");
    

	/*
	//Change Lable when in a Header/Footer View
	if (IOS7) {
		//[[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont systemFontOfSize:14]];
		[[UILabel appearanceWhenContainedIn:[self class], nil] setFont:[UIFont systemFontOfSize:14]];
	}
	[[UILabel appearanceWhenContainedIn:[self class], nil] setFont:[UIFont systemFontOfSize:15]];
	*/
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//Only show Cancel if it was presented by a view Controller...
	if (self.presentingViewController.presentedViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPress:)];
    }
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelDidPress:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - StyleHeaders
+ (NSString *)defaultHappyHeader {
	NSString *header = NSLocalizedStringFromTable(@"We would love to know how we can make %@ even better, and would appreciate it you left a review with the App Store.", @"TTSupportFeedBack", @"Happy Message");
	
	return [NSString stringWithFormat:header, self.appName];
}

+ (NSString *)defaultConfusedHeader {
	NSString *header = NSLocalizedStringFromTable(@"If you're unsure about how to use %@, please visit the User Guide or contact the %@ team.", @"TTSupportFeedBack", @"Confused Message");
	
	return [NSString stringWithFormat:header, self.appName, self.appName];
}

+ (NSString *)defaultUnhappyHeader {
	NSString *header = NSLocalizedStringFromTable(@"We would love to know how we can make %@ even better, and make your experience with %@ a Happy One.", @"TTSupportFeedBack", @"UnHappy Message");
	
	return [NSString stringWithFormat:header, self.appName, self.appName];
}


#pragma mark - Cells Setup
//Create Cells and assign the action to each
- (SupportOptionCellItem *)reviewCellInfo {
	SupportOptionCellItem *reviewItem = [SupportOptionCellItem new];
	reviewItem.title = NSLocalizedStringFromTable(@"Write a Review", @"TTSupportFeedBack", @"Write a Review");
	reviewItem.image = [UIImage imageNamed:@"TTSupport_review.png"];
	
	if (_tintColor) {
		reviewItem.tintImage = TRUE;
		reviewItem.tintColor = self.tintColor;
	}
	
	reviewItem.action = ^(TTSupportFeedBack *sender) {
		//NEED to supply the iOS App ID HERE..
		NSString *appID = [self getAppID];
		if (appID) {
			[Appirater setAppId:appID];
			[Appirater rateApp]; //Let the User Rate the App Now
		}
	};

	return reviewItem;
}

- (SupportOptionCellItem *)contactCellInfo {
	SupportOptionCellItem *contactItem = [SupportOptionCellItem new];
	NSString *title = NSLocalizedStringFromTable(@"Contact the %@ team", @"TTSupportFeedBack", @"Contact the %@ Team");
	contactItem.title =  [NSString stringWithFormat:title, self.appName];
	contactItem.image = [UIImage imageNamed:@"TTSupport_email.png"];
	
	if (_tintColor) {
		contactItem.tintImage = TRUE;
		contactItem.tintColor = self.tintColor;
	}
	contactItem.action = ^(TTSupportFeedBack *sender){
		if ([TTSupportFeedBackContactViewController isMailAvailable]) {
			TTSupportFeedBackContactViewController *svc = [[TTSupportFeedBackContactViewController alloc] initWithTopics:[TTSupportFeedBackContactViewController defaultTopics]];
			UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:svc];
			nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
			nvc.modalPresentationStyle = UIModalPresentationFormSheet;
			
			[self.navigationController pushViewController:svc animated:TRUE];
			
		}else{
			[self showAlertWithTitle:NSLocalizedStringFromTable(@"Support", @"TTSupportFeedBack", @"Support")
							 message:NSLocalizedStringFromTable(@"It seems you don't have email setup?", @"TTSupportFeedBack", @"It seems you don't have email setup?")];
			
		}
	};

	return contactItem;
}


- (SupportOptionCellItem *)userGuideCellInfo {
	SupportOptionCellItem *contactItem = [SupportOptionCellItem new];
	contactItem.title = NSLocalizedStringFromTable(@"User Guide", @"TTSupportFeedBack", @"User Guide");
	contactItem.image = [UIImage imageNamed:@"TTSupport_help.png"];
	if (_tintColor) {
		contactItem.tintImage = TRUE;
		contactItem.tintColor = self.tintColor;
	}
	contactItem.action = ^(TTSupportFeedBack *sender){
		
		[self showUserGuide];
	};
	
	return contactItem;
}

//Social Cells

- (NSString *)getDefaultMsg {
	NSString* base = NSLocalizedStringFromTable(@"I love using %@", @"TTSupportFeedBack", @":Default Msg");
	return [NSString stringWithFormat:base, self.appName];
}

- (SupportOptionCellItem *)twitterCellInfo {
	SupportOptionCellItem *twitterInfo = [SupportOptionCellItem new];
	NSString *title = NSLocalizedStringFromTable(@"Tweet about %@", @"TTSupportFeedBack", @"Tweet about %@");
	twitterInfo.title =  [NSString stringWithFormat:title, self.appName];

	twitterInfo.image = [UIImage imageNamed:@"TTSupport_twitter.png"];
	if (_tintColor) {
		twitterInfo.tintImage = TRUE;
		twitterInfo.tintColor = self.tintColor;
	}
	twitterInfo.action = ^(TTSupportFeedBack *sender){
		SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
		[controller setInitialText:[NSString stringWithFormat:@"%@ @%@",
									_socialMsg ? _socialMsg : [self getDefaultMsg],
									_twitterUsername ? _twitterUsername : self.appName]];

		[self.navigationController presentViewController:controller animated:YES completion:Nil];
		 
	};

	return twitterInfo;
}

- (SupportOptionCellItem *)faceBookCellInfo {
	SupportOptionCellItem *fbInfo = [SupportOptionCellItem new];
	NSString *title = NSLocalizedStringFromTable(@"Tell your friends about %@", @"TTSupportFeedBack", @"Tell your friends about %@");
	fbInfo.title =  [NSString stringWithFormat:title, self.appName];

	fbInfo.image = [UIImage imageNamed:@"TTSupport_facebook.png"];
	if (_tintColor) {
		fbInfo.tintImage = TRUE;
		fbInfo.tintColor = self.tintColor;
	}
	fbInfo.action = ^(TTSupportFeedBack *sender){
		//lets just let it tell the user they have to setup the account if it is iOS6+
		SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
		[controller setInitialText:_socialMsg ? _socialMsg : [self getDefaultMsg]];
		[self.navigationController presentViewController:controller animated:YES completion:Nil];
	};

	return fbInfo;
}

//Sina Weibo - 新浪微博 Chinese Twitter
- (SupportOptionCellItem *)sinaWeiboCellInfo {
	SupportOptionCellItem *sinaWeibo = [SupportOptionCellItem new];
	NSString *title = NSLocalizedStringFromTable(@"Share %@ on Weibo", @"TTSupportFeedBack", @"Share %@ on Weibo");
	sinaWeibo.title =  [NSString stringWithFormat:title, self.appName];

	sinaWeibo.image = [UIImage imageNamed:@"TTSupport_sinaweibo.png"];
	if (_tintColor) {
		sinaWeibo.tintImage = TRUE;
		sinaWeibo.tintColor = self.tintColor;
	}

	sinaWeibo.action = ^(TTSupportFeedBack *sender){
		//if Sina Weibo is setup in Settings
		SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
		[controller setInitialText:[NSString stringWithFormat:@"%@ @%@",
									_socialMsg ? _socialMsg : [self getDefaultMsg],
									_weiboUsername ? _weiboUsername : self.appName]];
		
		[self.navigationController presentViewController:controller animated:YES completion:Nil];
	};
	
	return sinaWeibo;
}



- (NSArray *)upperCellItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	
	if (_supportStyle != 0) {
		if (_supportStyle == kSupportStyleHappy) {
			if ([self getAppID]) {
				[result addObject:[self reviewCellInfo]];
			}
			[result addObject:[self contactCellInfo]];
		}
		
		if (_supportStyle == kSupportStyleConfused) {
			[result addObject:[self userGuideCellInfo]];
			[result addObject:[self contactCellInfo]];
		}
		
		if (_supportStyle == kSupportStyleUnHappy) {
			[result addObject:[self contactCellInfo]];
		}
	}
	
    return result.copy;
}

- (NSArray *)socialCellItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	
	if (_supportStyle != 0) {
		if (_supportStyle == kSupportStyleHappy) {
			[result addObject:[self twitterCellInfo]];
			[result addObject:[self faceBookCellInfo]];
			//If user has Sina Weibo Setup - show that as well.
			if([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo])
				[result addObject:[self sinaWeiboCellInfo]];

		}
	}
	
    return result.copy;
}



- (void)showAlertWithTitle:(NSString *)title message:(NSString *)msg{
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
													message:msg
												   delegate:nil
										  cancelButtonTitle:NSLocalizedStringFromTable(@"Cancel", @"TTSupportFeedBack", @"Cancel")
										  otherButtonTitles: nil];
	[alert show];
	
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.cellItems[(NSUInteger)section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kSupportSectionUpper:
            return _headerMsg;
            break;
        case kSupportSectionSocial:
            return NSLocalizedStringFromTable(@"Tell Your Friends", @"TTSupportFeedBack", @"Social Share Header");
            break;
        default:
            break;
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TTSupportFeedBackObject *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[[cellItem class] reuseIdentifier]];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[[cellItem class] reuseIdentifier]];
	}
		
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = [UIFont systemFontOfSize:14];

	[cellItem configureCell:cell atIndexPath:indexPath];

	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	TTSupportFeedBackObject *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
	//if action call that action
    if (cellItem.action) cellItem.action(self);
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - For User Guide
- (void) showUserGuide {
   //NOthing.. Do your own thing
	
	NSLog(@"User Guide was requested");
}



@end
