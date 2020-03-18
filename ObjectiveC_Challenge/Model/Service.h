//
//  Service.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 17/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

@interface Service : NSObject

- (void)fetchMovieDetails:(int)movieId completion:(void (^)(Movie*))callback;

@end
