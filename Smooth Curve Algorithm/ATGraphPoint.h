//  ATGraphPoint.h

//  Created by Amogh Talpallikar 


#import <Foundation/Foundation.h>

// To be used as a Wrapper for CGPoints, so that it can be added to Collections
@interface ATGraphPoint : NSObject {

}
@property(nonatomic,assign) double x;
@property(nonatomic,assign) double y;

-(CGPoint)CGPointValue;
+graphPointWithCGPoint:(CGPoint)inPoint;
@end
