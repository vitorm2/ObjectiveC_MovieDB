//
//  ViewController.h
//  ObjectiveC_Challenge
//
//  Created by Vitor Demenighi on 16/03/20.
//  Copyright © 2020 Vitor Demenighi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *popularMovies_tableView;
@property NSArray<Movie *> *popularMovies;


@end

