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

#import "SESManager.h"
#import "AmazonClientManager.h"

@implementation SESManager

/*
 * Uses Amazon SES http://aws.amazon.com/ses/
 * API: SendEmail http://docs.amazonwebservices.com/ses/latest/APIReference/API_SendEmail.html
 */
+(BOOL)sendBasicEmail:(NSString *)address
{
    SESContent *messageBody = [[[SESContent alloc] init] autorelease];
    messageBody.data = [NSString stringWithFormat: @"Greetings %@, from Amazon SES!", address];
    
    SESContent *subject = [[[SESContent alloc] init] autorelease];
    subject.data = [NSString stringWithFormat: @"Hello from SES"];
    
    SESBody *body = [[[SESBody alloc] init] autorelease];
    body.text = messageBody;
    
    SESMessage *message = [[[SESMessage alloc] init] autorelease];
    message.subject = subject;
    message.body    = body;
    
    SESDestination *destination = [[[SESDestination alloc] init] autorelease];
    [destination.bccAddresses addObject:VERIFIED_EMAIL];
    [destination.toAddresses addObject:address];
    
    SESSendEmailRequest *ser = [[[SESSendEmailRequest alloc] init] autorelease];
    ser.source      = VERIFIED_EMAIL;
    ser.destination = destination;
    ser.message     = message;
    
    SESSendEmailResponse *response = [[AmazonClientManager ses] sendEmail:ser];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
        return NO;
    }
    
    NSLog(@"Message sent, id %@", response.messageId);
    
    return YES;
}


+(BOOL)sendSillyEmail:(NSString *)address
				   CC:(NSString *)CC
				  CC2:(NSString *)CC2
				  BCC:(NSString *)BCC
				 BCC2:(NSString *)BCC2
{
    SESContent *messageBody = [[[SESContent alloc] init] autorelease];
    messageBody.data = [NSString stringWithFormat: @"Greetings %@, from Amazon SES!", address];
    
    SESContent *subject = [[[SESContent alloc] init] autorelease];
    subject.data = [NSString stringWithFormat: @"Hello from SES"];
    
    SESBody *body = [[[SESBody alloc] init] autorelease];
    body.text = messageBody;
    
    SESMessage *message = [[[SESMessage alloc] init] autorelease];
    message.subject = subject;
    message.body    = body;
    
    SESDestination *destination = [[[SESDestination alloc] init] autorelease];
    [destination.toAddresses addObject:address];
    [destination.ccAddresses addObject:CC];
    [destination.ccAddresses addObject:CC2];
    [destination.bccAddresses addObject:BCC];
    [destination.bccAddresses addObject:BCC2];
    
    SESSendEmailRequest *ser = [[[SESSendEmailRequest alloc] init] autorelease];
    ser.source      = address;
    ser.destination = destination;
    ser.message     = message;
    
    SESSendEmailResponse *response = [[AmazonClientManager ses] sendEmail:ser];
    if(response.error != nil)
    {
        NSLog(@"Error: %@", response.error);
        return NO;
    }
    
    NSLog(@"Message sent, id %@", response.messageId);
    
    return YES;
}

@end
