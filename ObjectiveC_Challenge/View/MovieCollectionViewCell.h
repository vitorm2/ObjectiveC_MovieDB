//
//  MovieCollectionViewCell.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 27/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface MovieCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CustomImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieVoteAverage;

@property (nonatomic) Movie *movie;

@end

NS_ASSUME_NONNULL_END
