//
//  CustomCell.m
//  Univer
//
//  Created by 백 운천 on 12. 11. 24..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake( 10, 10, 60, 60 );
    
    self.imageView.layer.cornerRadius = 3.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderColor = [UIColor clearColor].CGColor;
    
    
//    self.imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.imageView.layer.shadowOffset = CGSizeMake(0, 1);
//    self.imageView.layer.shadowOpacity = 1;
//    self.imageView.layer.shadowRadius = 1.0;
//    self.imageView.clipsToBounds = NO;


}

@end
