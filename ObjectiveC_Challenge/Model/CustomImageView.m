//
//  CustomImageView.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 26/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "CustomImageView.h"
#import "ViewController.h"
  
@implementation CustomImageView

- (void)loadImageWithStringURL:(NSString *) urlString {

    self.imageURL = urlString;
    
    NSURL *imgURL = [NSURL URLWithString: urlString];
    
    self.image = nil;
    
    if([imageCache objectForKey:urlString]) {
        self.image = [imageCache objectForKey:urlString];
        return;
    }

      [[NSURLSession.sharedSession dataTaskWithURL:(imgURL) completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
          if (!error) {
              UIImage *returnImage = [[UIImage alloc] initWithData:data];
              
              if (self.imageURL == urlString) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      self.image = returnImage;
                  });
              }
              
              [imageCache setObject:returnImage forKey:urlString];
              
          }else{
              NSLog(@"IMAGE FETCH ERROR: %@",error);
          }
      }] resume] ;
    
    
}

@end
