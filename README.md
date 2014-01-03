TTSupportFeedback
=================

A Support System inspired by the Ember application.

Can be presented by a UIActionSheet to ask the user how they feel about the application.  Based on the users response will show different screens with options on how to best contact you.

Supports the ability to:
Contact via e-mail
Access a User Guide
Share on Twitter/Facebook/Weibo

![](https://raw.github.com/khoogheem/TTSupportFeedback/master/Screenshots/ActionSheet.png)

### How to use:

Using Default Styles: (Happy, Unhappy, Confused)

TTSupportFeedBack *svc = [[TTSupportFeedBack alloc] initWithSupportStyle:kSupportStyleHappy tintColor:[UIColor greenColor]];
svc.socialMsg = @"This is the best ever";

[self presentViewController: [[UINavigationController alloc]initWithRootViewController:svc] animated:TRUE completion:nil];

![](https://raw.github.com/khoogheem/TTSupportFeedback/master/Screenshots/SupportOptions.png)

Use your own Header Messages:
UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:[[TTSupportFeedBack alloc] initWithFeedBackOptions:kFeedbackSupportGuide headerMsg:@"Why do you hate our App So Much???"]];
[self presentViewController:nvc animated:TRUE completion:nil];


![](https://raw.github.com/khoogheem/TTSupportFeedback/master/Screenshots/FeedBackScreen.png)
