//
//  Member.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"

@implementation Member

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.state = dictionary[@"state"];
        self.city = dictionary[@"city"];
        self.country = dictionary[@"country"];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo"][@"photo_link"]];
        self.memberImage = [UIImage new];
    }
    return self;
}

+(void)memberID:(NSString *)memberID retrieveMembersWithCompletion:(void (^)(Member *))complete{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/member/%@?&sign=true&photo-host=public&page=20&key=4d6c601a67667a11415d703b4f241540",memberID]];


    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        Member *member = [[Member alloc]initWithDictionary:results];
        NSLog(@"The url is: %@", member.photoURL);
        member.memberImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:member.photoURL]];
        NSLog(@"The url is: %@", member.memberImage);
        
        complete(member);
    }];
}

-(UIImage *)findImageforMemberWithURL:(NSURL *)url{
    
    UIImage *imageNew = [UIImage new];
    NSURLRequest *imageReq = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!connectionError) {
                [imageNew isEqual:[UIImage imageWithData:data]];
                NSLog(@"The image is filled with:  %@",imageNew);
            } else{
                [imageNew isEqual:[UIImage imageNamed:@"logo"]];
            }
        });
    }];
    return imageNew;
}

@end
