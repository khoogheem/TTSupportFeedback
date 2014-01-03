//
//  TTSupportFeedBackObject.m
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

#import "TTSupportFeedBackObject.h"
#import "UIImage+Utils.h"
#import "NSObject+SysInfo.h"

#define DefaultContentCellHeight 100

@implementation TTSupportFeedBackObject

+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleDefault;
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self.class);
}

- (CGFloat)cellHeight {
    return 44.0;
}

//MASTER Configure Cell
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end

//Topic Cell Items
@implementation FeedbackTopicCellItem

+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleValue1;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"Topic", @"TTSupportFeedBack", @"Topic");
    }
    return self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell atIndexPath:indexPath];
	
    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.topic;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
}

@end


@interface FeedbackContentCellItem ()
@property (nonatomic, strong) UITextField *textField;
@end

@implementation FeedbackContentCellItem


- (id)init {
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, 310, DefaultContentCellHeight)];
        self.textView.text = self.content;
        self.textView.delegate = self;
        self.textView.scrollEnabled = NO;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.backgroundColor = [UIColor clearColor];
		
		//Add The placeHolder
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, self.textView.frame.size.width, 20)];
        _textField.text = self.placeholder;
        _textField.font = [UIFont systemFontOfSize:14];
		_textField.alpha = 0.6f;
		_textField.userInteractionEnabled = NO;
        _textField.backgroundColor = [UIColor clearColor];
		_textField.hidden = NO;
		[self.textView addSubview:_textField];
    }
    return self;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell atIndexPath:indexPath];
	_textField.text = self.placeholder;
	[self.textField sizeToFit];
	[self.textField layoutIfNeeded];

    [cell.contentView addSubview:self.textView];
}

- (CGFloat)cellHeight {
    return MAX(DefaultContentCellHeight, self.textView.contentSize.height);
}

- (void)updatePlaceholder {
	if ([self.textView.text length] == 0) {
		_textField.hidden = !_textField.hidden;
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
	[self updatePlaceholder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	[self updatePlaceholder];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self willChangeValueForKey:kSupportFeedbackCellHeightKVO];
	
	
    CGRect frame = self.textView.frame;
	
    if (IOS_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [self.textView sizeToFit];
        [self.textView layoutIfNeeded];
    }
	
    frame.size.height = MAX(DefaultContentCellHeight, self.textView.contentSize.height);
    self.textView.frame = frame;
	
    [self didChangeValueForKey:kSupportFeedbackCellHeightKVO];
}

@end


//Device/App Info Cells
@implementation FeedbackInfoCellItem

+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleValue1;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [super configureCell:cell atIndexPath:indexPath];
	
	cell.backgroundColor = [UIColor clearColor];

    cell.textLabel.text = self.title;
    cell.detailTextLabel.text = self.value;
}

@end

@implementation SupportOptionCellItem

+ (UITableViewCellStyle)cellStyle {
    return UITableViewCellStyleDefault;
}

- (id)init {
    self = [super init];
    if (self) {
        self.image = nil;
		self.tintImage = FALSE;
		self.available = TRUE;
		self.tintColor = [UIColor blackColor];
    }
    return self;
}

- (UITableViewCell *)tintImageToAccentColorInCellView:(UITableViewCell *)cell {
	if (IOS7) {
		cell.imageView.image = [cell.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		cell.imageView.tintColor = self.tintColor;
	}
	
	return cell;
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	[super configureCell:cell atIndexPath:indexPath];
	
	if (self.available) {
		cell.textLabel.alpha = 1.0;
	}else {
		cell.textLabel.alpha = 0.4;
	}
    cell.textLabel.text = self.title;
	
	if (self.tintImage) {
		cell = [self tintImageToAccentColorInCellView:cell];
		self.image = [UIImage image:self.image tintWithColor:self.tintColor];
	}
	
	cell.imageView.image = self.image;

}

@end



