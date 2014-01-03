//
//  TTSupportFeedBackContactViewController.m
//
//  Created by Kevin A. Hoogheem on 12/18/13.
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

#import "TTSupportFeedBackContactViewController.h"
#import "TTSupportFeedBackTopicsTable.h"
#import "TTSupportFeedBackObject.h"
#import "NSObject+SysInfo.h"


#define USE_OLD_TABLE_INSETS 0

typedef NS_ENUM(NSInteger, FeedBackSections){
    kFeedbackSectionInput = 0,
    kFeedbackSectionDeviceInfo,
    kFeedbackSectionAppInfo
};


@implementation TopicObject

- (id)init {
    self = [super init];
    if (self) {
		self.topic = _topic;
		self.placeholder = _placeholder;
    }
    return self;
}
@end

@interface TTSupportFeedBackContactViewController ()

@property (nonatomic, retain) NSArray *topics;
@property (nonatomic, readonly) NSArray *topicNames;

@property (nonatomic, readonly) NSUInteger selectedTopicIndex;
@property (nonatomic, retain) NSString *selectedTopic;

//Holds the Cell Items
@property (nonatomic, retain) NSArray *cellItems;
//Array of the Cells
@property (nonatomic, readonly) NSMutableArray *inputCellItems;
@property (nonatomic, readonly) NSArray *deviceInfoCellItems;
@property (nonatomic, readonly) NSArray *appInfoCellItems;
@property (nonatomic, retain) FeedbackTopicCellItem *topicCellItem;
@property (nonatomic, retain) FeedbackContentCellItem *contentCellItem;
@end

@implementation TTSupportFeedBackContactViewController

+ (BOOL)isMailAvailable {
    return [MFMailComposeViewController canSendMail];
}

- (void)dealloc {
	//remove the observer on the cell height
	[self.contentCellItem removeObserver:self forKeyPath:kSupportFeedbackCellHeightKVO];
}

+ (NSArray *)defaultTopics {

	NSMutableArray *result = [[NSMutableArray alloc] init];
	
    TopicObject *question = [TopicObject new];
	question.topic = NSLocalizedStringFromTable(@"Question", @"TTSupportFeedBack", @"Question");
	question.placeholder = NSLocalizedStringFromTable(@"What is your Question?", @"TTSupportFeedBack", @"What is your Question");
    [result addObject:question];

	
    TopicObject *request = [TopicObject new];
	request.topic = NSLocalizedStringFromTable(@"Request", @"TTSupportFeedBack", @"Request");
	request.placeholder = NSLocalizedStringFromTable(@"What is your Request?", @"TTSupportFeedBack", @"What is your Request");
    [result addObject:request];
	
	TopicObject *bugReport = [TopicObject new];
	bugReport.topic = NSLocalizedStringFromTable(@"Bug Report", @"TTSupportFeedBack", @"Request");
	bugReport.placeholder = NSLocalizedStringFromTable(@"Let us know the Bug you found.", @"TTSupportFeedBack", @"Let us know the Bug you found.");
    [result addObject:bugReport];
	
	TopicObject *otherFeedback = [TopicObject new];
	otherFeedback.topic = NSLocalizedStringFromTable(@"Other", @"TTSupportFeedBack", @"Other");
	otherFeedback.placeholder = NSLocalizedStringFromTable(@"Let us know what you are thinking.", @"TTSupportFeedBack", @"Let us know what you are thinking.");
    [result addObject:otherFeedback];

    return result.copy;
}

- (NSArray *)topicNames {
	NSMutableArray *items = [[NSMutableArray alloc] init];
	for (TopicObject *obj in self.topics) {
		[items addObject:obj.topic];
	}
	
    return items.copy;
}

#pragma mark - Init
- (instancetype)initWithTopics:(NSArray *)theTopics {
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        self.topics = theTopics;
		
		//self.view.frame = [[UIScreen mainScreen] bounds];
		
		//Set the Selected Topic to the first in the array..
		TopicObject *topObject = (self.topics)[0];
		self.selectedTopic = topObject.topic;
		
		if (!IOS7) {
			//Set the Grouped Table Background view to nil
			[self.tableView setBackgroundView:nil];
		}
		//now set the color
		self.tableView.backgroundColor = [UIColor whiteColor];
		
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
			self.edgesForExtendedLayout = UIRectEdgeNone;
		
		//Set Use_OLD_TABLE_INSETS if you want the insets to look like pre-7
		if (IOS7 && USE_OLD_TABLE_INSETS){
			if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
				[self.tableView setSeparatorInset:UIEdgeInsetsZero];
			}
		}

    }
    return self;
}


#pragma mark - Views
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = NSLocalizedStringFromTable(@"Leave Feedback", @"TTSupportFeedBack", @"Page Title");
	
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"Send", @"TTSupportFeedBack", @"Send") style:UIBarButtonItemStyleDone target:self action:@selector(sendMailAction:)];

	self.tableView.showsVerticalScrollIndicator = FALSE;
	
	self.cellItems = @[self.inputCellItems, self.deviceInfoCellItems, self.appInfoCellItems];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	//Only show Cancel if it was presented by a view Controller...
	if (self.presentingViewController.presentedViewController) {
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDidPress:)];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)cancelDidPress:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


#pragma mark - Send Mail
- (void)sendMailAction:(id)sender {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:self.toRecipients];
    [controller setCcRecipients:self.ccRecipients];
    [controller setBccRecipients:self.bccRecipients];
    [controller setSubject:self.mailSubject];
    [controller setMessageBody:self.mailBody isHTML:NO];
    [self presentViewController:controller animated:YES completion:nil];
}

- (NSString *)mailSubject {
	TopicObject *topObject = (self.topics)[self.selectedTopicIndex];
	
    return [NSString stringWithFormat:@"Support: %@", topObject.topic];
}


- (NSString *)mailBody {
    NSString *content = self.contentCellItem.textView.text;
    NSString *body = [NSString stringWithFormat:@"%@\n\n\nDevice: %@\niOS: %@\nApp: %@\nVersion: %@\nBuild: %@",
					  content,
					  self.platformString,
					  self.osVersionString,
					  self.appName,
					  self.appVersion,
					  self.appBuild];
    return body;
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {

    [controller dismissViewControllerAnimated:TRUE completion:nil];
}


- (NSUInteger)selectedTopicIndex{
    return [self.topicNames indexOfObject:self.selectedTopic];
}

#pragma mark - Table Cell Setup
- (NSMutableArray *)inputCellItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];

    self.topicCellItem = [FeedbackTopicCellItem new];
	TopicObject *topObject = (self.topics)[self.selectedTopicIndex];
	self.topicCellItem.topic = topObject.topic;
	
	__weak typeof (self) weakSelf = self;

	self.topicCellItem.action = ^(TTSupportFeedBackContactViewController *sender) {
		//Send the topics to the TopicView
        TTSupportFeedBackTopicsTable *topicsViewController = [[TTSupportFeedBackTopicsTable alloc] initWithStyle:UITableViewStyleGrouped];
        topicsViewController.topics = sender.topicNames;
		
        topicsViewController.action = ^(NSString *selectedTopic) {
			//Set the topic they picked
			
            weakSelf.selectedTopic = selectedTopic;
			
			//update the Topic
			NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:kFeedbackSectionInput];
            FeedbackTopicCellItem *cellItem = weakSelf.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
			TopicObject *topObject = (weakSelf.topics)[weakSelf.selectedTopicIndex];
			cellItem.topic = topObject.topic;
			[weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

			//update the Content placeholder
			NSIndexPath *contentCellPath = [NSIndexPath indexPathForRow:1 inSection:kFeedbackSectionInput];
			FeedbackContentCellItem *contentCell = weakSelf.cellItems[(NSUInteger)contentCellPath.section][(NSUInteger)contentCellPath.row];
			contentCell.placeholder = topObject.placeholder;
			[weakSelf.tableView reloadRowsAtIndexPaths:@[contentCellPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
        [sender.navigationController pushViewController:topicsViewController animated:YES];
    };
    [result addObject:self.topicCellItem];

    self.contentCellItem = [FeedbackContentCellItem new];
	if (topObject.placeholder != nil) {
		self.contentCellItem.placeholder = topObject.placeholder;
	}else{
		self.contentCellItem.placeholder = NSLocalizedStringFromTable(@"Please leave us your feedback", @"TTSupportFeedBack", @"default comment placeholder");
	}
 
    [self.contentCellItem addObserver:self forKeyPath:kSupportFeedbackCellHeightKVO options:NSKeyValueObservingOptionNew context:nil];
    [result addObject:self.contentCellItem];

	return result.copy;
}

- (NSArray *)deviceInfoCellItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	
    FeedbackInfoCellItem *platformItem = [FeedbackInfoCellItem new];
	platformItem.title = NSLocalizedStringFromTable(@"Device", @"TTSupportFeedBack", @"Device");
	platformItem.value = self.platformString;
    [result addObject:platformItem];
	
	FeedbackInfoCellItem *systemVersionItem = [FeedbackInfoCellItem new];
	systemVersionItem.title = @"iOS"; //no need to localize this..
	systemVersionItem.value = self.osVersionString;
    [result addObject:systemVersionItem];
	
    return result.copy;
}

- (NSArray *)appInfoCellItems {
    NSMutableArray *result = [[NSMutableArray alloc] init];
	
    FeedbackInfoCellItem *nameItem = [FeedbackInfoCellItem new];
	nameItem.title = NSLocalizedStringFromTable(@"Name", @"TTSupportFeedBack", @"Name");
    nameItem.value = self.appName;
    [result addObject:nameItem];
	
    FeedbackInfoCellItem *versionItem = [FeedbackInfoCellItem new];
	versionItem.title = NSLocalizedStringFromTable(@"Version", @"TTSupportFeedBack", @"Version");
    versionItem.value = self.appVersion;
    [result addObject:versionItem];
	
    FeedbackInfoCellItem *buildItem = [FeedbackInfoCellItem new];
	buildItem.title = NSLocalizedStringFromTable(@"Build", @"TTSupportFeedBack", @"Build");
    buildItem.value = self.appBuild;
    [result addObject:buildItem];
	
    return result.copy;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellItems[(NSUInteger)section] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kFeedbackSectionInput:
           // return NSLocalizedStringFromTable(@"Topics", @"TTSupportFeedBack", @"Topics");
            break;
        case kFeedbackSectionDeviceInfo:
            return NSLocalizedStringFromTable(@"Device Info", @"TTSupportFeedBack", @"Device Info");
            break;
		case kFeedbackSectionAppInfo:
            return NSLocalizedStringFromTable(@"App Info", @"TTSupportFeedBack", @"App Info");
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
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[[cellItem class] reuseIdentifier]];
	}

	//NSLog(@"Cell: %@", cell);
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
	
	[cellItem configureCell:cell atIndexPath:indexPath];


    return cell;
}

#pragma mark - Key value observing
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context {

	//observe the CellHeight and change depending on the new height
    if ([keyPath isEqualToString:kSupportFeedbackCellHeightKVO]) {
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTSupportFeedBackObject *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    return cellItem.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	TTSupportFeedBackObject *cellItem = self.cellItems[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];
    if (cellItem.action && self.topics.count > 1) cellItem.action(self);
	
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.contentCellItem.textView resignFirstResponder];
}


@end
