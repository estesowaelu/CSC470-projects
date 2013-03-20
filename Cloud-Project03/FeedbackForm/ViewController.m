/*
 * Copyright 2010-2012 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#import "ViewController.h"
#import "Constants.h"
#import "AmazonClientManager.h"
#import "SESManager.h"


@implementation ViewController

@synthesize addressField = _addressField;
@synthesize CCField = _CCField;
@synthesize BCCField = _BCCField;
@synthesize CCField2 = _CCField2;
@synthesize BCCField2 = _BCCField2;
@synthesize sendButton = _sendButton;
@synthesize sendCC = _sendCC;
@synthesize verifyButton = _verifyButton;
@synthesize removeButton = _removeButton;
@synthesize viewAddressesButton = _viewAddressesButton;
@synthesize viewAccountButton = _viewAccountButton;
@synthesize scrollView = _scrollView;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"AWS-SES";

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

    self.scrollView.contentSize = self.view.frame.size;
}

- (void)viewDidUnload
{
	[self setCCField:nil];
	[self setBCCField:nil];
	[self setVerifyButton:nil];
	[self setRemoveButton:nil];
	[self setViewAddressesButton:nil];
	[self setViewAccountButton:nil];
	[self setCCField2:nil];
	[self setBCCField2:nil];
	[self setSendCC:nil];
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.addressField     = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![AmazonClientManager hasCredentials]) {
        [[Constants credentialsAlert] show];
    }
    else {
        self.sendButton.enabled = YES;
        self.sendCC.enabled = YES;
        self.verifyButton.enabled = YES;
        self.removeButton.enabled = YES;
        self.viewAddressesButton.enabled = YES;
        self.viewAccountButton.enabled = YES;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_addressField release];
    [_sendButton release];
    [_scrollView release];

	[_CCField release];
	[_BCCField release];
	[_verifyButton release];
	[_removeButton release];
	[_viewAddressesButton release];
	[_viewAccountButton release];
	[_CCField2 release];
	[_BCCField2 release];
	[_sendCC release];
    [super dealloc];
}

#pragma mark - IBActions

-(IBAction)submit:(id)sender
{
    [self.addressField resignFirstResponder];

    if (self.addressField.text == nil || self.addressField.text.length == 0) {
        
        [[[[UIAlertView alloc] initWithTitle:@"Message Not Sent"
                                     message:@"Please enter an email address."
                                    delegate:nil
                           cancelButtonTitle:@"Oops"
                           otherButtonTitles:nil] autorelease] show];
        return;
    }

    NSString *addressText = self.addressField.text;

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        dispatch_async(dispatch_get_main_queue(), ^{

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });

        BOOL didSucceed = [SESManager sendBasicEmail:addressText];

        dispatch_async(dispatch_get_main_queue(), ^{

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            if (didSucceed) {

                [[[[UIAlertView alloc] initWithTitle:@"Message Sent"
                                             message:@"Good work!"
                                            delegate:nil
                                   cancelButtonTitle:@"Woo"
                                   otherButtonTitles:nil] autorelease] show];
            }
            else {
                [[[[UIAlertView alloc] initWithTitle:@"Message Dropped"
                                             message:@"Sorry. That didn't work for some reason."
                                            delegate:nil
                                   cancelButtonTitle:@"Aww"
                                   otherButtonTitles:nil] autorelease] show];
            }
        });
    });
}

- (IBAction)submitCC:(id)sender {
    [self.addressField resignFirstResponder];
    [self.CCField resignFirstResponder];
    [self.CCField2 resignFirstResponder];
    [self.BCCField resignFirstResponder];
    [self.BCCField2 resignFirstResponder];
	
    if (self.addressField.text == nil || self.addressField.text.length == 0
        || self.CCField.text == nil || self.CCField.text.length == 0
        || self.CCField2.text == nil || self.CCField2.text.length == 0
        || self.BCCField.text == nil || self.BCCField.text.length == 0
        || self.BCCField2.text == nil || self.BCCField2.text.length == 0) {
        
        [[[[UIAlertView alloc] initWithTitle:@"Message Not Sent"
                                     message:@"I know it's silly, but put in five addresses, okay?"
                                    delegate:nil
                           cancelButtonTitle:@"Ffiiine"
                           otherButtonTitles:nil] autorelease] show];
        return;
    }
	
    NSString *addressText = self.addressField.text;
    NSString *CCText = self.CCField.text;
    NSString *CC2Text = self.CCField2.text;
    NSString *BCCText = self.BCCField.text;
    NSString *BCC2Text = self.BCCField2.text;
	
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
		
        dispatch_async(dispatch_get_main_queue(), ^{
			
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });
		
        BOOL didSucceed = [SESManager sendSillyEmail:addressText
												  CC:CCText
												 CC2:CC2Text
												 BCC:BCCText
												BCC2:BCC2Text];
		
        dispatch_async(dispatch_get_main_queue(), ^{
			
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
            if (didSucceed) {
				
                [[[[UIAlertView alloc] initWithTitle:@"Message Sent"
                                             message:@"Good work!"
                                            delegate:nil
                                   cancelButtonTitle:@"Woo"
                                   otherButtonTitles:nil] autorelease] show];
            }
            else {
                [[[[UIAlertView alloc] initWithTitle:@"Message Dropped"
                                             message:@"Sorry. That didn't work for some reason."
                                            delegate:nil
                                   cancelButtonTitle:@"Aww"
                                   otherButtonTitles:nil] autorelease] show];
            }
        });
    });
}

- (IBAction)verify:(id)sender {
}

- (IBAction)remove:(id)sender {
}

- (IBAction)viewAddresses:(id)sender {	
}

- (IBAction)viewAccount:(id)sender {
}

#pragma mark - Helper Methods

- (void)keyboardDidShown:(NSNotification *)notification
{
    CGSize kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark

@end