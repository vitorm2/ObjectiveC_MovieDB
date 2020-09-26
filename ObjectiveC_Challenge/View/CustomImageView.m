//
//  CustomImageView.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 26/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "CustomImageView.h"
#import "ViewController.h"
#import "ImageCache.h"
  
@implementation CustomImageView

- (void)loadImageWithStringURL:(NSString *) urlString {

    self.imageURL = urlString;
    
    self.image = nil;
    
    if([[ImageCache.sharedManager cache] objectForKey:urlString]) {
        self.image = [[ImageCache.sharedManager cache] objectForKey:urlString];
        return;
    }
    
    [Service fetchImageData: urlString completion:^(UIImage * returnImage) {
        
        if (self.imageURL == urlString) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.image = returnImage;
            });
        }
        
        [[ImageCache.sharedManager cache] setObject:returnImage forKey:urlString];
    }];
    
    
}

@end
