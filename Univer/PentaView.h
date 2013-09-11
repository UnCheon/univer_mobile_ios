//
//  PentaView.h
//  Univer
//
//  Created by 백 운천 on 12. 10. 5..
//  Copyright (c) 2012년 백 운천. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PentaView : UIView
{
	CGContextRef cgContext;
	CGLayerRef cgLayer;

}

- (void)pentaA:(CGPoint)a B:(CGPoint)b C:(CGPoint)c D:(CGPoint)d E:(CGPoint)e;


@end
