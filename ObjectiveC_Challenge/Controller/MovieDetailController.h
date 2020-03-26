//
//  MovieDetailController.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 19/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieDetailController : UIViewController

@property NSNumber *movieID;
@property Movie *movie;

@property (weak, nonatomic) IBOutlet UIImageView *movieDetailImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieGenreLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteAverageLabel;
@property (weak, nonatomic) IBOutlet UITextView *movieOverviewTextView;

@end

NS_ASSUME_NONNULL_END
