//
//  Post.h
//
//  Copyright (c) 2014 Automattic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Post : NSManagedObject

@property (nonatomic, retain) NSString * short_URL;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * site_name;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * postID;
@property (nonatomic, retain) NSNumber * siteID;

+(void)createOrUpdateWithDictionary:(NSDictionary *)dict withContext:(NSManagedObjectContext *)context;
-(void)updateFromDictionary:(NSDictionary *)dict;

@end
