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

#import <Foundation/Foundation.h>

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// This sample App is for demonstration purposes only.
// It is not secure to embed your credentials into source code.
// Please read the following article for getting credentials
// to devices securely.
// http://aws.amazon.com/articles/Mobile/4611615499399490
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#define ACCESS_KEY_ID                @"AKIAJ62VBCRGUQCQ3NTA"
#define SECRET_KEY                   @"2+r6jtc14R8M5HPJzp8efxOKu75hbNe4AwQMDxbU"
#define CREDENTIALS_ALERT_MESSAGE    @"Please update the Constants.h file with your credentials or Token Vending Machine URL."

// make sure to set this an e-mail address that has been verified in SES 
#define VERIFIED_EMAIL               @"honeywe4@tcnj.edu"

@interface Constants:NSObject {
}

+(UIAlertView *)credentialsAlert;

@end
