//
//  ViewController.h
//  HYN
//
//  Created by 이승희 on 03/02/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;

@end

