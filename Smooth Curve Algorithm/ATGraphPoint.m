//  ATGraphPoint.m

//  Created by Amogh Talpallikar 

#import "ATGraphPoint.h"


@implementation ATGraphPoint


@synthesize x;
@synthesize y;
-(CGPoint)CGPointValue{
    return CGPointMake(self.x,self.y);
}
+graphPointWithCGPoint:(CGPoint)inPoint{
    ATGraphPoint *graphPoint =  [[ATGraphPoint alloc ] init];
    graphPoint.x  = inPoint.x;
    graphPoint.y  = inPoint.y;
    
    return [graphPoint autorelease];
}
@end
