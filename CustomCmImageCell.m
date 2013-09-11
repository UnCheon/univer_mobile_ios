//
//  CustomCmImageCell.m
//  Univer
//
//  Created by 백 운천 on 12. 11. 24..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "CustomCmImageCell.h"

@implementation CustomCmImageCell

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
    self.imageView.frame = CGRectMake(5, 80, 310, 200);
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView setClearsContextBeforeDrawing:YES];
    [self.imageView setClipsToBounds:YES];
}


@end
