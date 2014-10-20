//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
        self.eventPhoto = [UIImage new];
    }
    return self;
}

+(void)searchKeyWord:(NSString *)keyword retrieveEventsWithCompletion:(void (^)(NSArray *))complete{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=4d6c601a67667a11415d703b4f241540",keyword]];
//    NSLog(@"Wrong %@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
       NSArray *results = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectForKey:@"results"];
       
       NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:results.count];
       
       for (NSDictionary *dictionary in results) {
           Event *event = [[Event alloc]initWithDictionary:dictionary];
//           NSLog(@"This is right %@", event.photoURL);
           event.eventPhoto = [event findImageForEventWithURL:event.photoURL];
//           NSLog(@" Why %@",event.eventPhoto);
           [newArray addObject:event];
           
       }
       complete(newArray);
    }];
}

-(UIImage *)findImageForEventWithURL: (NSURL *)url{
    UIImage *imageNew = [UIImage new];
//        NSLog(@"Wrong %@",url);
        NSURLRequest *imageReq = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!connectionError) {
                    [imageNew isEqual:[UIImage imageWithData:data]];
                } else{
                    [imageNew isEqual:[UIImage imageNamed:@"logo"]];
                }
            });
        }];
    
    return imageNew;
}

@end
