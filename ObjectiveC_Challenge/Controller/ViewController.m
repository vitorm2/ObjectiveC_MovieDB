//
//  ViewController.m
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 16/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "Movie.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Movie *myMovie =[[Movie alloc] init];
    myMovie.videoId = 10;
    
    [myMovie someFunction];
    
    NSLog(@"movieId: %d", myMovie.videoId);
   
}



@end
