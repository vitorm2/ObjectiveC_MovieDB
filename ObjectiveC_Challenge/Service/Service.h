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

typedef enum moviesCategoryType {
    POPULAR,
    NOW_PLAYING
} moviesCategory;

@property NSString *const urlBase;

+ (void) fetchImageData:(NSString* )imageURL completion:(void (^)(UIImage *))callback;

+ (void) fetchMovieDetails:(NSNumber* )movieId completion:(void (^)(Movie*))callback;

+ (void) fetchMovies:(moviesCategory)moviesCategory completion: (void (^)(NSMutableArray*))callback;

+ (void) searchMovies:(NSString *)searchString completion: (void (^)(NSMutableArray*))callback;


@end
