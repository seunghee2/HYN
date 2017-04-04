//
//  TabBarViewController.m
//  HYN
//
//  Created by 이승희 on 04/04/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "InformationViewController.h"
#import "StatsViewController.h"
#import "UserViewController.h"

@interface TabBarViewController () <UITabBarDelegate, UITabBarControllerDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    NSArray *array = self.tabBar.items;
    
    NSArray *imgArray = [NSArray arrayWithObjects:@"bottom_category_home", @"bottom_category_info", @"bottom_category_statistics", @"bottom_category_myinfo", nil];
    NSArray *selImgArray = [NSArray arrayWithObjects:@"bottom_category_home_selected", @"bottom_category_info_selected", @"bottom_category_statistics_selected", @"bottom_category_myinfo_selected", nil];
    
    for (int i = 0; i < array.count; i++) {
        UITabBarItem *item = [array objectAtIndex: i];
        item.image = [UIImage imageNamed:[imgArray objectAtIndex:i]];
        UIImage* selImage = [UIImage imageNamed:[selImgArray objectAtIndex: i]];
        
        selImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = selImage;
        item.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}
    
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSArray *array = [viewController childViewControllers];
    if (![array[0] isKindOfClass: [HomeViewController class]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"알림" message:@"준비중입니다." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return NO;
    }
    return YES;
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
