//
//  ViewController.m
//  HYN
//
//  Created by 이승희 on 03/02/2017.
//  Copyright © 2017 이승희. All rights reserved.
//

#import "HomeViewController.h"
#import "MenuTableViewCell.h"

@implementation NSString (Support)
- (NSComparisonResult) sortForIndex:(NSString*)comp {
    NSString* left = [NSString stringWithFormat:@"%@%@", [self localizedCaseInsensitiveCompare:@"ㄱ"]+1 ? @"0" : !([self localizedCaseInsensitiveCompare:@"a"]+1) ? @"2" : @"1", self];
    
    NSString* right = [NSString stringWithFormat:@"%@%@", [comp localizedCaseInsensitiveCompare:@"ㄱ"]+1 ? @"0" : !([comp localizedCaseInsensitiveCompare:@"a"]+1) ? @"2": @"1", comp];
    
    return [left localizedCaseInsensitiveCompare:right];
}
@end

@interface HomeViewController () {
    NSMutableArray *dataArray;
    NSArray *menuArray;
    NSMutableArray *titleArray;
    NSMutableArray *percentageArray;
    NSMutableArray *frameArray;
    NSString *menu;
    BOOL isSortedByFavorites;
    NSURLRequest *request;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UIButton *button_bob;
@property (weak, nonatomic) IBOutlet UIButton *button_noodle;
@property (weak, nonatomic) IBOutlet UIButton *button_fastfood;
@property (weak, nonatomic) IBOutlet UIButton *button_meat;
@property (weak, nonatomic) IBOutlet UIButton *button_cafe;
@property (weak, nonatomic) IBOutlet UIButton *button_beer;
    
@property (weak, nonatomic) IBOutlet UIButton *sorting_by_favorites;
@property (weak, nonatomic) IBOutlet UIButton *sorting_by_hangul;

@end

@implementation HomeViewController
@synthesize responseData = _responseData;
    
- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    
    [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob_selected"] forState:UIControlStateNormal];
    [self.sorting_by_favorites setImage:[UIImage imageNamed:@"sort_popular_selected"] forState:UIControlStateNormal];
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDate *now = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.responseData = [NSMutableData data];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://168.188.127.132:8000/lineup/current/?time=%@", [dateFormatter stringFromDate: now]]]];
    
    [[NSURLConnection alloc] initWithRequest:request delegate: self];
}
    


#pragma mark - NSURLConnection Delegates
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
    
    dataArray = [[NSMutableArray alloc] init];
    menuArray = [[NSArray alloc] init];
    for (id key in res) {
        id value = [res objectForKey: key];
        NSArray *data = [NSArray arrayWithObjects: (NSString *) key, (NSString *) value, nil];
        [dataArray addObject: data];
    }
    
    NSArray *temp = [dataArray objectAtIndex: 4];
    menuArray = [temp objectAtIndex: 1];
    [self setPercentageArray];
    [self sortingByFavorites];
    [self.menuTableView reloadData];
}

    
#pragma mark - Custom methods
    
- (IBAction) reloadAction:(id)sender {
    [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob_selected"] forState:UIControlStateNormal];
    [self.sorting_by_favorites setImage:[UIImage imageNamed:@"sort_popular_selected"] forState:UIControlStateNormal];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    self.responseData = [NSMutableData data];
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://168.188.127.132:8000/lineup/current/?time=%@", [dateFormatter stringFromDate: now]]]];
    [[NSURLConnection alloc] initWithRequest:request delegate: self];
}
    
    
- (IBAction) selectSortingMethod:(UIButton *)sender {
    if (sender.tag == 0) {
        [self.sorting_by_favorites setImage:[UIImage imageNamed:@"sort_popular_selected"] forState:UIControlStateNormal];
        [self.sorting_by_hangul setImage:[UIImage imageNamed:@"sort_text"] forState: UIControlStateNormal];
        [self sortingByFavorites];
    } else {
        [self.sorting_by_favorites setImage:[UIImage imageNamed:@"sort_popular"] forState:UIControlStateNormal];
        [self.sorting_by_hangul setImage:[UIImage imageNamed:@"sort_text_selected"] forState:UIControlStateNormal];
        [self sortingByHangul];
    }
}
    
- (void) sortingByFavorites {
    isSortedByFavorites = TRUE;
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"proportion" ascending: NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    menuArray = [menuArray sortedArrayUsingDescriptors:sortDescriptors];
    [self setPercentageArray];
    [self.menuTableView reloadData];
}

- (void) sortingByHangul {
    isSortedByFavorites = FALSE;
    NSSortDescriptor *brandDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending: YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:brandDescriptor];
    menuArray = [menuArray sortedArrayUsingDescriptors:sortDescriptors];
    [self setPercentageArray];
    [self.menuTableView reloadData];
}
    
    
- (IBAction) selectMenus:(UIButton *)sender {
    switch (sender.tag) {
        case 0: {
            NSLog(@"%ld", (long)sender.tag);
            [sender setImage:[UIImage imageNamed:@"category_01_bob_selected"] forState:UIControlStateNormal];
            [self.button_noodle setImage:[UIImage imageNamed:@"category_02_noddle"] forState:UIControlStateNormal];
            [self.button_fastfood setImage:[UIImage imageNamed:@"category_03_fastfood"] forState: UIControlStateNormal];
            [self.button_meat setImage:[UIImage imageNamed:@"category_04_fork"] forState:UIControlStateNormal];
            [self.button_cafe setImage:[UIImage imageNamed:@"category_05_cafe"] forState:UIControlStateNormal];
            [self.button_beer setImage:[UIImage imageNamed:@"category_06_drink"] forState:UIControlStateNormal];
            NSArray *temp = [dataArray objectAtIndex: 4];
            menuArray = [temp objectAtIndex: 1];
            break;
        }
        case 1: {
            NSLog(@"%ld", (long)sender.tag);
            NSArray *temp = [dataArray objectAtIndex: 5];
            [sender setImage:[UIImage imageNamed:@"category_02_noddle_selected"] forState:UIControlStateNormal];
            [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob"] forState:UIControlStateNormal];
            [self.button_fastfood setImage:[UIImage imageNamed:@"category_03_fastfood"] forState: UIControlStateNormal];
            [self.button_meat setImage:[UIImage imageNamed:@"category_04_fork"] forState:UIControlStateNormal];
            [self.button_cafe setImage:[UIImage imageNamed:@"category_05_cafe"] forState:UIControlStateNormal];
            [self.button_beer setImage:[UIImage imageNamed:@"category_06_drink"] forState:UIControlStateNormal];
            menuArray = [temp objectAtIndex: 1];
            break;
        }
        case 2: {
            NSLog(@"%ld", (long)sender.tag);
            NSArray *temp = [dataArray objectAtIndex: 1];
            [sender setImage:[UIImage imageNamed:@"category_03_fastfood_selected"] forState:UIControlStateNormal];
            [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob"] forState:UIControlStateNormal];
            [self.button_noodle setImage:[UIImage imageNamed:@"category_02_noddle"] forState:UIControlStateNormal];
            [self.button_meat setImage:[UIImage imageNamed:@"category_04_fork"] forState:UIControlStateNormal];
            [self.button_cafe setImage:[UIImage imageNamed:@"category_05_cafe"] forState:UIControlStateNormal];
            [self.button_beer setImage:[UIImage imageNamed:@"category_06_drink"] forState:UIControlStateNormal];
            menuArray = [temp objectAtIndex: 1];
            break;
        }
        case 3:{
            NSLog(@"%ld", (long)sender.tag);
            NSArray *temp = [dataArray objectAtIndex: 3];
            [sender setImage:[UIImage imageNamed:@"category_04_fork_selected"] forState:UIControlStateNormal];
            [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob"] forState:UIControlStateNormal];
            [self.button_noodle setImage:[UIImage imageNamed:@"category_02_noddle"] forState:UIControlStateNormal];
            [self.button_fastfood setImage:[UIImage imageNamed:@"category_03_fastfood"] forState:UIControlStateNormal];
            [self.button_cafe setImage:[UIImage imageNamed:@"category_05_cafe"] forState:UIControlStateNormal];
            [self.button_beer setImage:[UIImage imageNamed:@"category_06_drink"] forState:UIControlStateNormal];
            menuArray = [temp objectAtIndex: 1];
            break;
        }
        case 4:{
            NSLog(@"%ld", (long)sender.tag);
            NSArray *temp = [dataArray objectAtIndex: 2];
            [sender setImage:[UIImage imageNamed:@"category_05_cafe_selected"] forState:UIControlStateNormal];
            [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob"] forState:UIControlStateNormal];
            [self.button_noodle setImage:[UIImage imageNamed:@"category_02_noddle"] forState:UIControlStateNormal];
            [self.button_fastfood setImage:[UIImage imageNamed:@"category_03_fastfood"] forState:UIControlStateNormal];
            [self.button_meat setImage:[UIImage imageNamed:@"category_04_fork"] forState:UIControlStateNormal];
            [self.button_beer setImage:[UIImage imageNamed:@"category_06_drink"] forState:UIControlStateNormal];

            menuArray = [temp objectAtIndex: 1];
            break;
        }
        case 5:{
            NSLog(@"%ld", (long)sender.tag);
            NSArray *temp = [dataArray objectAtIndex: 0];
            [sender setImage:[UIImage imageNamed:@"category_06_drink_selected"] forState:UIControlStateNormal];
            [self.button_bob setImage:[UIImage imageNamed:@"category_01_bob"] forState:UIControlStateNormal];
            [self.button_noodle setImage:[UIImage imageNamed:@"category_02_noddle"] forState:UIControlStateNormal];
            [self.button_fastfood setImage:[UIImage imageNamed:@"category_03_fastfood"] forState:UIControlStateNormal];
            [self.button_cafe setImage:[UIImage imageNamed:@"category_05_cafe"] forState:UIControlStateNormal];
            [self.button_meat setImage:[UIImage imageNamed:@"category_04_fork"] forState:UIControlStateNormal];

            menuArray = [temp objectAtIndex: 1];
            break;
        }
        default:
            break;
    }
    if (isSortedByFavorites) {
        [self sortingByFavorites];
    } else {
        [self sortingByHangul];
    }
}
    
    
- (void) setPercentageArray {
    percentageArray = [[NSMutableArray alloc] init];
    titleArray = [[NSMutableArray alloc] init];
    
    
    for (int i = 0; i < menuArray.count; i++) {
        NSDictionary *temp = [menuArray objectAtIndex: i];
        [titleArray addObject:[temp valueForKey:@"title"]];
        [percentageArray addObject: [temp valueForKey:@"proportion"]];
    }
}
    
#pragma mark - TableView Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"menuCell";
    MenuTableViewCell *cell = (MenuTableViewCell *)[tableView dequeueReusableCellWithIdentifier: cellId];
    if (!cell) {
        NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"MenuTableViewCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
    }
    
    BOOL hasContentView = [cell.subviews containsObject:cell.contentView];
    if (!hasContentView) {
        [cell addSubview:cell.contentView];
    }
    
    int row = (int)[indexPath row];
    if (indexPath.section == 0) {
        cell.titleLabel.text = [titleArray objectAtIndex: row];
        cell.percentageLabel.text = [NSString stringWithFormat:@"%@", [percentageArray objectAtIndex: row]];
       // CGRect frame = cell.frame;
       // frame.size.width = frame.size.width * (float)[[percentageArray objectAtIndex: row] longValue] / 100;
       // cell.percentageView.frame = frame;
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
