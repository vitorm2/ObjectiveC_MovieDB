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
    myMovie.videoId = 10;
    
    [myMovie someFunction];
    
    NSLog(@"movieId: %d", myMovie.videoId);
    
    
    Service *myService = [[Service alloc] init];
   
    [myService getDataFrom:@"https://api.themoviedb.org/3/movie/550?api_key=79bb37b9869aa0ed97dc7a23c93d0829"];
    
}





@end
