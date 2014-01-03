//
//  ViewController.m
//  TTSupportFeedbackDemo
//
//  Created by Kevin A. Hoogheem on 1/2/14.
//  Copyright (c) 2014 Kevin A. Hoogheem. All rights reserved.
//

#import "ViewController.h"
#import "TTSupportFeedBack.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showOnlySocial:(id)sender {
	UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:[[TTSupportFeedBack alloc] initWithFeedBackOptions:kFeedBackSocial headerMsg:@"This is a test to just show the Social Feedback Section.  Email is a constant section"]];
	
	nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	nvc.navigationBar.translucent = FALSE;
	
	[self presentViewController:nvc animated:TRUE completion:nil];
	
	
}

- (IBAction)showCustom:(id)sender {
	UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:[[TTSupportFeedBack alloc] initWithFeedBackOptions:kFeedbackSupportGuide headerMsg:@"Why do you hate our App So Much???"]];
	
	nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	nvc.modalPresentationStyle = UIModalPresentationFormSheet;
	nvc.navigationBar.translucent = FALSE;
	
	[self presentViewController:nvc animated:TRUE completion:nil];
	
}

- (IBAction)showActionSheet:(id)sender {
	
	
	NSString *sheetTitle = NSLocalizedStringFromTable(@"How do you feel about", @"TTSupportFeedBack", @"How do you feel about (App Name - auto inserted)");
	NSString *actionSheetTitle = [NSString stringWithFormat:@"%@ %@",sheetTitle, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]];
	NSString *happy = NSLocalizedStringFromTable(@"Happy", @"TTSupportFeedBack", @"Happy");
	NSString *confussed = NSLocalizedStringFromTable(@"Confused", @"TTSupportFeedBack", @"Confused");
	NSString *unhappy = NSLocalizedStringFromTable(@"Unhappy", @"TTSupportFeedBack", @"Unhappy");
	NSString *cancelTitle = NSLocalizedStringFromTable(@"Cancel", @"TTSupportFeedBack", @"Cancel");
	UIActionSheet *actionSheet = [[UIActionSheet alloc]
								  initWithTitle:actionSheetTitle
								  delegate:self
								  cancelButtonTitle:cancelTitle
								  destructiveButtonTitle:nil
								  otherButtonTitles:happy, confussed, unhappy, nil];
	
	//[actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
	[actionSheet showInView:self.view];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	UINavigationController *nvc = nil;
	TTSupportFeedBack *svc = nil;
	
	switch (buttonIndex) {
		case 0:
			//Happy
			//*** Option to tint the image
			svc = [[TTSupportFeedBack alloc] initWithSupportStyle:kSupportStyleHappy tintColor:[UIColor greenColor]];
			svc.socialMsg = @"This is the best ever";
			
			nvc = [[UINavigationController alloc]initWithRootViewController:svc];
			break;
		case 1:
			//Confussed
			nvc = [[UINavigationController alloc]initWithRootViewController:[[TTSupportFeedBack alloc] initWithSupportStyle:kSupportStyleConfused]];
			break;
		case 2:
			//Unhappy
			nvc = [[UINavigationController alloc]initWithRootViewController:[[TTSupportFeedBack alloc] initWithSupportStyle:kSupportStyleUnHappy]];
			break;
		case 3:
			NSLog(@"Cancel");
			break;
			
		default:
			break;
	}
	
	if (nvc != nil) {
		nvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		nvc.modalPresentationStyle = UIModalPresentationFormSheet;
		nvc.navigationBar.translucent = FALSE;
		
		[self presentViewController:nvc animated:TRUE completion:nil];
		
	}
	
}

@end
