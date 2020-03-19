//
//  Movie.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 17/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Movie : NSObject

@property NSNumber *movieID;
@property NSString *title;
@property NSString *overview;
@property NSString *genres;
@property NSNumber *vote_avegare;
@property NSString *imageURL;
@property UIImage *movieImage;

@end


