//
//  ImageCache.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 26/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject

@property (nonatomic, retain) NSCache *shared;

+ (id)sharedManager;

@end

NS_ASSUME_NONNULL_END
