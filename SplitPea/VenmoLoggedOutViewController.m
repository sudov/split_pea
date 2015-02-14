//
//  VenmoLoggedOutViewController.m
//  SplitPea
//
//  Created by Vinizzle on 2/13/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//
#import "VenmoLoggedOutViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>

@interface VenmoLoggedOutViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logInButton;

@end

@implementation VenmoLoggedOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logInButton.layer.borderColor = self.logInButton.tintColor.CGColor;
    self.logInButton.layer.borderWidth = 1.0f;
    self.logInButton.layer.cornerRadius = 4.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([[Venmo sharedInstance] isSessionValid]) {
        [self presentLoggedInVC];
    }
}

- (void)presentLoggedInVC {
    [self performSegueWithIdentifier:@"presentLoggedInVC" sender:self];
}

- (IBAction)logInButtonAction:(id)sender {
    printf("in1");
    [[Venmo sharedInstance] requestPermissions:@[VENPermissionMakePayments,
                                                 VENPermissionAccessProfile]
                         withCompletionHandler:^(BOOL success, NSError *error) {
                             if (success) {
                                 printf("in2");
                                 [self presentLoggedInVC];
                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Authorization failed"
                                                                                     message:error.localizedDescription
                                                                                    delegate:self
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
//                                 alertView.tapBlock = ^(UIAlertView *alertView, NSInteger buttonIndex) {
//                                     [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
//                                 };
                             }
                         }];
}

// Log out
- (IBAction)unwindFromLoggedInVC:(UIStoryboardSegue *)segue {
    [[Venmo sharedInstance] logout];
}

@end