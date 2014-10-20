//
//  MemberViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Member.h"
#import "MemberViewController.h"

@interface MemberViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) Member *member;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoImageView.alpha = 0;
    [Member memberID:self.memberID retrieveMembersWithCompletion:^(Member *member) {
        self.member = member;
        self.nameLabel.text = self.member.name;
        self.photoImageView.image = self.member.memberImage;
    }];
    
    self.photoImageView.backgroundColor = [UIColor greenColor];
    

}

-(void)setMember:(Member *)member{
    _member = member;
}




@end
