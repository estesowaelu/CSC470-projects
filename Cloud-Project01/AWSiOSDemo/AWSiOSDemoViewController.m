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

#import "AWSiOSDemoViewController.h"
#import "Constants.h"

#import "BucketList.h"
#import "AmazonClientManager.h"

//#import "S3AsyncViewController.h"
//#import "S3NSOperationDemoViewController.h"

@implementation AWSiOSDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"AWS-S3";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Home"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    [backButton release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (![AmazonClientManager hasCredentials]) {
        [[Constants credentialsAlert] show];
    }
}

-(IBAction)listBuckets:(id)sender
{
    if (![AmazonClientManager hasCredentials]) {
        [[Constants credentialsAlert] show];
    }
    else {
        BucketList *bucketList = [[BucketList alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:bucketList animated:YES];
        [bucketList release];
    }
}

-(IBAction)searchBuckets:(id)sender
{
    if (![AmazonClientManager hasCredentials]) {
        [[Constants credentialsAlert] show];
    }
/*    else {
        S3AsyncViewController *s3Async = [S3AsyncViewController new];
        [self.navigationController pushViewController:s3Async animated:YES];
        [s3Async release];
    }*/
}

@end