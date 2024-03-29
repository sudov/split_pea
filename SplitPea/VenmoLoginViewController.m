//
//  VenmoLoginViewController.m
//  SplitPea
//
//  Created by Vinizzle on 2/13/15.
//  Copyright (c) 2015 OkraLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VenmoLoginViewController.h"
#import <Venmo-iOS-SDK/Venmo.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <Parse/Parse.h>

@interface VenmoLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation VenmoLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    VENUser *user = [[Venmo sharedInstance] session].user;
    self.imageView.layer.borderColor = self.infoLabel.textColor.CGColor;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0f;
    self.imageView.layer.masksToBounds = YES;
    [self.imageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.infoLabel.text = [NSString stringWithFormat:@"Logged in as %@", user.displayName];
    
    PFUser *current_user = [PFUser currentUser];
    current_user[@"venmoDisplayName"]  = user.username;
    [current_user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //
        }
    }];

}

- (IBAction)unwindFromPaymentVC:(UIStoryboardSegue *)segue {
    
}



@end