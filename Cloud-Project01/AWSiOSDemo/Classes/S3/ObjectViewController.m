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

#import "ObjectViewController.h"
#import "AmazonClientManager.h"

@implementation ObjectViewController

@synthesize objectNameLabel, objectDataLabel, objectName, bucket;

-(IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deleteObject:(id)sender {
	S3DeleteObjectResponse *response = [[AmazonClientManager s3] deleteObjectWithKey:self.objectName withBucket:self.bucket];
	
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)copyObject:(id)sender {
    [objectNameLabel resignFirstResponder];
    [objectDataLabel resignFirstResponder];
	[copyDestination resignFirstResponder];
    
    NSData *data = [objectDataLabel.text dataUsingEncoding:NSUTF8StringEncoding];
    
	S3CopyObjectRequest *request = [[[S3CopyObjectRequest alloc] initWithSourceKey:objectNameLabel.text sourceBucket:bucket destinationKey:objectNameLabel.text destinationBucket:copyDestination.text] autorelease];
    S3CopyObjectResponse *response = [[AmazonClientManager s3] copyObject:request];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{

        dispatch_async(dispatch_get_main_queue(), ^{

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        });

        S3GetObjectRequest  *getObjectRequest  = [[[S3GetObjectRequest alloc] initWithKey:self.objectName withBucket:self.bucket] autorelease];
        S3GetObjectResponse *getObjectResponse = [[AmazonClientManager s3] getObject:getObjectRequest];
        if(getObjectResponse.error != nil)
        {
            NSLog(@"Error: %@", getObjectResponse.error);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            self.objectNameLabel.text = self.objectName;
            self.objectDataLabel.text = [[[NSString alloc] initWithData:getObjectResponse.body encoding:NSUTF8StringEncoding] autorelease];
        });
    });
    
}

-(void)dealloc
{
    [objectMetaKey release];
    [objectMetaValue release];
    [_objectMetaKey release];
    [_objectMetaValue release];
	[copyDestination release];
    [super dealloc];
}

- (void)viewDidUnload {
    [objectMetaKey release];
    objectMetaKey = nil;
    [objectMetaValue release];
    objectMetaValue = nil;
    [self setObjectMetaKey:nil];
    [self setObjectMetaValue:nil];
	[copyDestination release];
	copyDestination = nil;
    [super viewDidUnload];
}
@end