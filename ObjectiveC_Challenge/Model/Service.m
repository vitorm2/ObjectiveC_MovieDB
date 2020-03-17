//
//  Service.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 17/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Service.h"

@implementation Service

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    
//    [request setHTTPBody:body];
//    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;

    // requisiton call
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];

    // 200 = retornou o objeto movie
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }

    // Falta fazer o parsing
    
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

@end
