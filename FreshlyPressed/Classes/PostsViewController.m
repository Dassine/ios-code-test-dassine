//
//  MasterViewController.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "PostsViewController.h"
#import "PostViewController.h"
#import "AFHTTPSessionManager.h"
#import "Post.h"
#import "NSString+ISO8601DateFormatter.h"
#import "NSDate+FuzzyRelativeTime.h"
#import "PostTableViewCell.h"
#import "CompactPostTableViewCell.h"
#import "LoadingView.h"


@interface PostsViewController ()
@property(nonatomic) BOOL isCompact;
@property(nonatomic, strong) LoadingView *loadingView;
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation PostsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Set Loading view
    _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_loadingView];
    
    //Left Button - Toggle to compact posts list or nomal posts list
    UIImage *image = [UIImage imageNamed:@"compact-posts"];
    UIBarButtonItem *toggleButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(togglePressed)];
    self.navigationItem.leftBarButtonItem = toggleButton;
    
    //Right button - reload posts
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadPosts)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
    //Load posts to display for the first time
    [self loadPosts];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Set compact post cell when compact is set to true. If not set the post cell
    if (!_isCompact) {
        PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
        
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
    } else {
        CompactPostTableViewCell *cell = (CompactPostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CompactPostCell" forIndexPath:indexPath];
        
        [self configureCompactCell:cell atIndexPath:indexPath];
        return cell;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        //Set post data to display in Post Detail
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Post *post = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setPost:post];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _isCompact ? 37.0 : 57.0;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if (!_isCompact) {
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            } else {
                [self configureCompactCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(PostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupWithTitle:[[object valueForKey:@"title"] description]
                    date:[[object valueForKey:@"date"] fuzzyRelativeTimeFromNow]
             andImageUrl:[object valueForKey:@"image"]];
}

- (void)configureCompactCell:(CompactPostTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell setupWithTitle:[[object valueForKey:@"title"] description]];
}

#pragma mark - Posts

- (void)loadPosts
{
    [_loadingView setHidden:NO];
    
    //Server call to get posts data and store it in the app CoreData
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://public-api.wordpress.com/rest/v1.1/read/sites/53424024/posts/?number=25" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        
        NSArray *posts = [responseObject objectForKey:@"posts"];
        
        for (id singlePost in posts) {
            [Post createOrUpdateWithDictionary: singlePost withContext: context];
        }
        
        [context save:nil];
        
        //Hide the loading view
        [_loadingView setHidden:YES];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)togglePressed
{
    //Set the new state of the left bar button and reload the table
    _isCompact = !_isCompact;
    
    UIImage * image  = [UIImage imageNamed:(!_isCompact)  ? @"compact-posts" : @"posts"];
    [self.navigationItem.leftBarButtonItem setImage:image];
    
    [self.tableView reloadData];
}

@end
