//
//  Comment.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Comment.h"

@implementation Comment


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.author = dictionary[@"member_name"];
        self.date = [Comment dateFromNumber:dictionary[@"time"]];
        self.text = dictionary[@"comment"];
        self.memberID = dictionary[@"member_id"];
    }
    return self;
}


+(void)eventIDNumber:(NSString *)eventID retrieveCommentsForEventWithCompletion:(void (^)(NSArray *))complete{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=4d6c601a67667a11415d703b4f241540",eventID]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSArray *results = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectForKey:@"results"];
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:results.count];
        for (NSDictionary *dictionary in results) {
            Comment *comment = [[Comment alloc]initWithDictionary:dictionary];
            [newArray addObject:comment];
        }
        complete(newArray);
     }];
}


+ (NSDate *) dateFromNumber:(NSNumber *)number
{
    NSNumber *time = [NSNumber numberWithDouble:([number doubleValue] )];
    NSTimeInterval interval = [time doubleValue];
    return  [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
