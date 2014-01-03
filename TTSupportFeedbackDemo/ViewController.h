//
//  ViewController.h
//  TTSupportFeedbackDemo
//
//  Created by Kevin A. Hoogheem on 1/2/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIActionSheetDelegate>

- (IBAction)showActionSheet:(id)sender;

- (IBAction)showCustom:(id)sender;

- (IBAction)showOnlySocial:(id)sender;

@end
