//
//  Post.m
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import "Post.h"
#import "NSString+ISO8601DateFormatter.h"

@implementation Post

@dynamic short_URL;
@dynamic title;
@dynamic site_name;
@dynamic image;
@dynamic date;
@dynamic postID;
@dynamic siteID;

+(void)createOrUpdateWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context
{
    NSNumber *postID = [dict objectForKey:@"ID"];
    NSNumber *siteID = [dict objectForKey:@"site_ID"];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Post"];
    request.predicate = [NSPredicate predicateWithFormat:@"(postID = %@) AND (siteID = %@)", postID, siteID];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    request.fetchLimit = 1;
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if(error != nil){
        NSLog(@"Something bad happened: %@", error);
        return;
    }
    
    Post *post;
    if ([results count] > 0) {
        post = (Post *)[results objectAtIndex:0];
    } else {
        post = (Post *)[NSEntityDescription insertNewObjectForEntityForName:@"Post"
                                                           inManagedObjectContext:context];
        post.postID = postID;
        post.siteID = siteID;
    }
    
    [post updateFromDictionary:dict];
}

-(void)updateFromDictionary:(NSDictionary *)dict
{
    NSString *short_URL = [dict objectForKey:@"short_URL"];
    NSString *title = [dict objectForKey:@"title"];
    NSString *site_name = [dict objectForKey:@"site_name"];
    NSDate *date = [[dict objectForKey:@"date"] iso8601Value];
    NSString *image = [dict objectForKey:@"featured_image"];

    self.short_URL = short_URL;
    self.title = title;
    self.site_name = site_name;
    self.date = date;
    self.image = image;
}

@end
