//
//  TTSupportFeedBackTopicsTable.m
//
//  Created by Kevin A. Hoogheem on 12/20/13.
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

#import "TTSupportFeedBackTopicsTable.h"
#import "NSObject+SysInfo.h"


#define USE_OLD_TABLE_INSETS 0

@interface TTSupportFeedBackTopicsTable ()

@end

@implementation TTSupportFeedBackTopicsTable

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
		
		self.title =  NSLocalizedStringFromTable(@"Topics", @"TTSupportFeedBack", @"Topics");

		if (!IOS7) {
			//Set the Grouped Table Background view to nil
			[self.tableView setBackgroundView:nil];
		}
		//now set the color
		self.tableView.backgroundColor = [UIColor whiteColor];
		
		if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
			self.edgesForExtendedLayout = UIRectEdgeNone;
		
		//KEVIN - If iOS7 Style app we will use iOS7 SeparatorInsets.. else old style (full width)
		if (IOS7 && USE_OLD_TABLE_INSETS){
			if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
				[self.tableView setSeparatorInset:UIEdgeInsetsZero];
			}
		}

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSString *topic = self.topics[(NSUInteger)indexPath.row];
	cell.textLabel.text = topic;

    //cell.textLabel.text = topic;
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.font = [UIFont systemFontOfSize:14];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"TopicCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	
    // Configure the cell...
	[self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedTopic = self.topics[(NSUInteger)indexPath.row];
	//set the action to the selected topic and dismiss nav
    if (self.action) self.action(selectedTopic);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
