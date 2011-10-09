//
//  BlueLineView.h
//  BlueLine
//
//  Created by alex hunsley on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Method;
@class BlueLineGenerator;

@interface BlueLineView : UIView {
	float offsetX;
	float offsetY;
	float scaleX;
	float scaleY;
}

@property (retain, nonatomic) Method *method;
@property (retain, nonatomic) BlueLineGenerator *blg;

@property (nonatomic) float leftMargin;
@property (nonatomic) float rightMargin;
@property (nonatomic) float topMargin;
@property (nonatomic) float bottomMargin;

@property (readonly, nonatomic) CGRect viewSize;

- (void)setMethod:(Method *)m placeBell:(int)placeBell;
	
@end
