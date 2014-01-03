//
//  TTSupportFeedBackObject.h
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

#import <Foundation/Foundation.h>

#define kSupportFeedbackCellHeightKVO @"cellHeight"

@interface TTSupportFeedBackObject : NSObject

+ (UITableViewCellStyle)cellStyle;
+ (NSString *)reuseIdentifier;

@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, copy) void (^action)(id sender);

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


//Topic Picker
@interface FeedbackTopicCellItem : TTSupportFeedBackObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *topic;
@end

//Feeback Text
@interface FeedbackContentCellItem : TTSupportFeedBackObject <UITextViewDelegate>
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UITextView *textView;
@end


//App/Device Info
@interface FeedbackInfoCellItem : TTSupportFeedBackObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@end


@interface SupportOptionCellItem : TTSupportFeedBackObject

@property (nonatomic, copy) NSString *title;		//The Title of the cell
@property (nonatomic, assign) BOOL available;		//If set False will still show option but set as alpha 0.4f
@property (nonatomic, copy) UIImage *image;			//The Image for the Feedback Cell
@property (nonatomic, assign) BOOL tintImage;		//If True will set the color of the icons to the tintColor
@property (nonatomic, strong) UIColor *tintColor;	//Optionally can change the color of the icons
@end
