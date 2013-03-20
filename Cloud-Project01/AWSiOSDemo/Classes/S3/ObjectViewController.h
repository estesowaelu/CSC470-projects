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

#import <UIKit/UIKit.h>


@interface ObjectViewController:UIViewController {
    NSString         *objectName;
    NSString         *bucket;
	NSString		 *destination;
	
	IBOutlet UITextField *copyDestination;
    IBOutlet UILabel *objectNameLabel;
    IBOutlet UILabel *objectDataLabel;
	IBOutlet UILabel *objectMetaKey;
	IBOutlet UILabel *objectMetaValue;
}

@property (nonatomic, retain) IBOutlet UILabel *objectNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *objectDataLabel;
@property (retain, nonatomic) IBOutlet UILabel *objectMetaKey;
@property (retain, nonatomic) IBOutlet UILabel *objectMetaValue;

@property (nonatomic, retain) NSString         *objectName;
@property (nonatomic, retain) NSString         *bucket;
@property (nonatomic, retain) NSString         *destination;

- (IBAction)done:(id)sender;
- (IBAction)deleteObject:(id)sender;
- (IBAction)copyObject:(id)sender;

@end
