//
//  ViewController.m
//  HYN
//
//  Created by 이승희 on 03/02/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()
@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation HomeViewController
@synthesize responseData = _responseData;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.responseData = [NSMutableData data];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://168.188.127.132:8000/lineup/current/?time=%@", [dateFormatter stringFromDate: now]]]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate: self];
}
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data", (unsigned long)[self.responseData length]);
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData: self.responseData options: NSJSONReadingMutableContainers error:&myError];
    
    
    for (id key in res) {
        id value = [res objectForKey: key];
        NSString *keyAsString = (NSString *) key;
        NSString *valueAsString = (NSString *) value;
        
        NSLog(@"key : %@", keyAsString);
        NSLog(@"value : %@", valueAsString);
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
