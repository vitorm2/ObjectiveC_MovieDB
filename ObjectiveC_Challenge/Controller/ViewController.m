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
#import "Service.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Movie *myMovie =[[Movie alloc] init];

    
    Service *myService = [[Service alloc] init];
   
    [myService fetchMovieDetails:500 completion:^(Movie * movieDetails) {
        NSLog(movieDetails.title);
    }];
}





@end
