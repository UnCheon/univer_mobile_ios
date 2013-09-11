//
//  PentaView.m
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import "PentaView.h"

@implementation PentaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		cgContext = CGBitmapContextCreate(NULL, frame.size.width, frame.size.height, 8, 4*frame.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
		CGColorSpaceRelease(colorSpace);
        
        CGContextSetLineWidth(cgContext, 3);
        CGContextSetLineCap(cgContext, kCGLineCapRound);
        CGContextSetRGBStrokeColor(cgContext, 0.4, 0.2, 0.5, 1.0);
        
        CGFloat r = frame.size.height/2;
        
        CGPoint a = CGPointMake(r*cos(0.3141594)+r, r-r*sin(0.3141594));
        CGPoint b = CGPointMake(r*cos(1.570797)+r, r-r*sin(1.570797));
        CGPoint c = CGPointMake(r*cos(2.8274346)+r, r-r*sin(2.8274346));
        CGPoint d = CGPointMake(r*cos(4.0840722)+r, r-r*sin(4.0840722));
        CGPoint e = CGPointMake(r*cos(5.3407098)+r, r-r*sin(5.3407098));
        
        UILabel *aLable = [[UILabel alloc] initWithFrame:CGRectMake(a.x-40+27, a.y-21, 60, 21)];
        UILabel *bLable = [[UILabel alloc] initWithFrame:CGRectMake(b.x-40+2, b.y-21-6, 60, 21)];
        UILabel *cLable = [[UILabel alloc] initWithFrame:CGRectMake(c.x-40-10, c.y-21, 60, 21)];
        UILabel *dLable = [[UILabel alloc] initWithFrame:CGRectMake(d.x-40-20, d.y-21+20, 60, 21)];
        UILabel *eLable = [[UILabel alloc] initWithFrame:CGRectMake(e.x-40+40, e.y-21+20, 60, 21)];
        
        aLable.backgroundColor = [UIColor clearColor];
        bLable.backgroundColor = [UIColor clearColor];
        cLable.backgroundColor = [UIColor clearColor];
        dLable.backgroundColor = [UIColor clearColor];
        eLable.backgroundColor = [UIColor clearColor];
        
        aLable.textAlignment = UIBaselineAdjustmentAlignCenters;
        bLable.textAlignment = UIBaselineAdjustmentAlignCenters;
        cLable.textAlignment = UIBaselineAdjustmentAlignCenters;
        dLable.textAlignment = UIBaselineAdjustmentAlignCenters;
        eLable.textAlignment = UIBaselineAdjustmentAlignCenters;
        
        
        
        aLable.text = @"인성";
        bLable.text = @"강의 질";
        cLable.text = @"학점";
        dLable.text = @"출석";
        eLable.text = @"레포트";
        
        [self addSubview:aLable];
        [self addSubview:bLable];
        [self addSubview:cLable];
        [self addSubview:dLable];
        [self addSubview:eLable];
        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = [self bounds];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGImageRef image = CGBitmapContextCreateImage(cgContext);
    CGContextDrawImage(context, bounds, image);
    CGImageRelease(image);
    
}

- (void)pentaA:(CGPoint)a B:(CGPoint)b C:(CGPoint)c D:(CGPoint)d E:(CGPoint)e
{
    CGContextBeginPath(cgContext);
    
    CGContextMoveToPoint(cgContext, a.x, a.y);
    CGContextAddLineToPoint(cgContext, b.x, b.y);
    CGContextStrokePath(cgContext);
    
    CGContextMoveToPoint(cgContext, b.x, b.y);
    CGContextAddLineToPoint(cgContext, c.x, c.y);
    CGContextStrokePath(cgContext);
    
    CGContextMoveToPoint(cgContext, c.x, c.y);
    CGContextAddLineToPoint(cgContext, d.x, d.y);
    CGContextStrokePath(cgContext);
    
    CGContextMoveToPoint(cgContext, d.x, d.y);
    CGContextAddLineToPoint(cgContext, e.x, e.y);
    CGContextStrokePath(cgContext);
    
    CGContextMoveToPoint(cgContext, e.x, e.y);
    CGContextAddLineToPoint(cgContext, a.x, a.y);
    CGContextStrokePath(cgContext);
    
    [self setNeedsDisplay];
}


@end
