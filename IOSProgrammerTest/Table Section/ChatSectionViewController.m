//
//  TableSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

/*
 CLASS SUMMARY:
 - Added  self.tableView.estimatedRowHeight = 90; and return UITableViewAutomaticDimension for row height and disabled scrolling to achieve dynamic row height based on the text in the cell.
 
 - The image view was implemented in the ChatCell class to keep this class simple and clean
 
 */


#import "ChatSectionViewController.h"
#import "MainMenuViewController.h"
#import "ChatCell.h"


//#define TABLE_CELL_HEIGHT 45.0f
#define TABLE_CELL_HEIGHT 100.0f

@interface ChatSectionViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *loadedChatData;

@end

@implementation ChatSectionViewController


// MARK: View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 90;
    
    self.loadedChatData = [[NSMutableArray alloc] init];
    [self loadJSONData];
}




// MARK: Class Methods

- (void)loadJSONData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"chatData" ofType:@"json"];

    NSError *error = nil;

    NSData *rawData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error];

    id JSONData = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingAllowFragments error:&error];

    [self.loadedChatData removeAllObjects];
    if ([JSONData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *jsonDict = (NSDictionary *)JSONData;

        NSArray *loadedArray = [jsonDict objectForKey:@"data"];
        if ([loadedArray isKindOfClass:[NSArray class]])
        {
            for (NSDictionary *chatDict in loadedArray)
            {
                ChatData *chatData = [[ChatData alloc] init];
                [chatData loadWithDictionary:chatDict];
                [self.loadedChatData addObject:chatData];
                
            }
        }
    }

    [self.tableView reloadData];
}




// MARK: - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ChatCell";
    ChatCell *cell = nil;

    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = (ChatCell *)[nib objectAtIndex:0];
    }

    ChatData *chatData = [self.loadedChatData objectAtIndex:[indexPath row]];
    [cell loadWithData:chatData];

    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.loadedChatData.count;
}


// MARK: - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




// MARK: Actions

- (IBAction)backAction:(id)sender
{
//    MainMenuViewController *mainMenuViewController = [[MainMenuViewController alloc] init];
//    [self.navigationController pushViewController:mainMenuViewController animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}






@end
