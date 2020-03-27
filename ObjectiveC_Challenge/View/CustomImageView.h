//
//  CustomImageView.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 26/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomImageView : UIImageView

@property (nullable) NSString *imageURL;

-(void) loadImageWithStringURL: (NSString *)urlString;

@end

NS_ASSUME_NONNULL_END
