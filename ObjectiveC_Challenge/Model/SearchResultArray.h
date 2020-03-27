//
//  ResultRequestSearch.h
//  ObjectiveC_Challenge
//
//  Created by Guilherme Rangel on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SearchResult.h"

@interface SearchResultArray : NSObject

@property NSNumber *page;
@property NSNumber *total_results;
@property NSNumber *total_pages;
@property NSArray<SearchResultArray *> *results;


@end



