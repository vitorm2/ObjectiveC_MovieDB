//
//  Parse.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Parse : NSObject

+ (Movie *) parseMovie: (NSDictionary *) movieDic;
+ (NSMutableArray<Movie *> *) parseMovies: (NSDictionary *) moviesDic;


@end

NS_ASSUME_NONNULL_END
