
//  ATSmoothCurveAlgorithm.m

//
//  Created by Amogh Talpallikar

#import "ATSmoothCurveAlgorithm.h"
#import "ATGraphPoint.h"

// This Algorithm is adopted from the C# version available on http://www.codeproject.com/KB/graphics/BezierATline.aATx
@implementation ATSmoothCurveAlgorithm


//method to fill array with NSNull till the first n .
/* This is important because the algorithm in C# version uses normal arrays where you can insert objects at random indices but here I am using a collection and I cant insert an object at index i until it has objects upto that number so I use this method to fill up an array with NSNull objects which are wrapper for nil in collections which cannot store nil.*/
+(void)makeArrayElementsNilTill:(int)n forArray:(NSMutableArray*)inArray{
	[inArray retain];
	[inArray removeAllObjects];
	for (int i = 0; i < n; ++i) {
		[inArray addObject:[NSNull null]];
	}
	
	[inArray release];
	
}

// This method accepts three array objects.
//knots(the points to draw curve through) are processed 
//and calculated control points for each curve in the ATline is stored correATonding arrays.
+(BOOL)getFromKnots:(NSMutableArray*)inKnots FirstControlPoints:(NSMutableArray*)outFirstControlPoints
andSecondControlPoints:(NSMutableArray*)outSecondControlPoints 
{
	NSLog(@"in algorith method %@",inKnots);
	
	[inKnots retain];
	[outFirstControlPoints retain];
	[outSecondControlPoints retain];
	int i;
	if (inKnots==nil) {
		return NO;//[NSException raise:@"inKnots is NIL" format:@""];
	}
	if (outFirstControlPoints == nil) {
		return NO;//[NSException raise:@"outFirstControlPoints is NIL" format:@""];
	}
	if (outSecondControlPoints==nil ) {
		return NO;//[NSException raise:@"outSecondControlPoints parameter is NIL" format:@""];
	}
	
	int n = [inKnots count]-1;
	if (n<1) {
		return NO;//[NSException raise:@"Less than two knot Points in inKnots." format:@"inKnots has %d knot.",n+1];
	}
	
	
	[self makeArrayElementsNilTill:n forArray:outFirstControlPoints];
	[self makeArrayElementsNilTill:n forArray:outSecondControlPoints];
	
	
	
	
	double tempDouble;
	if(n == 1){
		ATGraphPoint* tempPoint = [[ATGraphPoint alloc] init];
		tempPoint.x = (2*[[inKnots objectAtIndex:0] x]  + [[inKnots objectAtIndex:1] x])/3;
		tempPoint.y = (2*[[inKnots objectAtIndex:0] y] + [[inKnots objectAtIndex:1] y])/3;
		[outFirstControlPoints replaceObjectAtIndex:0 withObject:tempPoint];
		
		tempPoint.x = (2*tempPoint.x - [[inKnots objectAtIndex:0] x]);
		tempPoint.y = (2*tempPoint.y - [[inKnots objectAtIndex:0] y]);
		[outSecondControlPoints replaceObjectAtIndex:0 withObject:tempPoint];
		[tempPoint release];
		return YES;
	}
	
	NSMutableArray *RHS = [[NSMutableArray alloc]init];
	[self makeArrayElementsNilTill:([inKnots count]-1) forArray:RHS ];
	
	// Set right hand side X values
	
	for (i = 1; i < n - 1; ++i){
		
		tempDouble = 4 * [[inKnots objectAtIndex:i] x] + 2 *[[inKnots objectAtIndex: i+1] x];
		
		[RHS replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:tempDouble]];
		
		
		
	}
	tempDouble = [[inKnots objectAtIndex:0] x] + 2 * [[inKnots objectAtIndex:1] x];
	[RHS replaceObjectAtIndex:0 withObject:  [NSNumber numberWithDouble:tempDouble] ];
	
	tempDouble = (8 * [[inKnots objectAtIndex: n-1] x] + [[inKnots objectAtIndex: n] x])/2.0;
	
	[RHS replaceObjectAtIndex:n-1 withObject:[NSNumber numberWithDouble:tempDouble]];
	
	NSMutableArray *x = [self getFirstControlPointsFromRHS:RHS];
	
	
	// Set right hand side y values
	
	for (i = 1; i < n - 1; ++i){
		
		tempDouble = 4 * [[inKnots objectAtIndex:i] y] + 2 *[[inKnots objectAtIndex: i+1] y];
		
		[RHS replaceObjectAtIndex:i withObject: [NSNumber numberWithDouble:tempDouble]];
	}
	tempDouble = [[inKnots objectAtIndex:0] y] + 2 * [[inKnots objectAtIndex:1] y];
	[RHS replaceObjectAtIndex:0 withObject: [NSNumber numberWithDouble:tempDouble]];
	
	tempDouble = (8 * [[inKnots objectAtIndex: n-1] y] + [[inKnots objectAtIndex: n] y])/2.0;
	
	[RHS replaceObjectAtIndex:n-1 withObject: [NSNumber numberWithDouble:tempDouble]];
	
	NSMutableArray *y = [self getFirstControlPointsFromRHS:RHS];
	// Fill output arrays.
	
	
	for (i = 0; i < n; ++i){
		
		//firstControlPoints[i] = new Point(x[i], y[i]);
		 ATGraphPoint* tempPoint = [[ATGraphPoint alloc] init];
		tempPoint.x = [[x objectAtIndex:i] doubleValue];
		 tempPoint.y = [[y objectAtIndex:i] doubleValue];
		
		[outFirstControlPoints replaceObjectAtIndex:i withObject:tempPoint];
		
		if (i < n - 1){
			
			tempPoint.x = 2 * [[inKnots objectAtIndex: i+1] x] - [[x objectAtIndex:i+1] doubleValue];
			tempPoint.y = 2 * [[inKnots objectAtIndex: i+1] y] - [[y objectAtIndex:i+1] doubleValue];
			
			[outSecondControlPoints replaceObjectAtIndex:i withObject:tempPoint ];
		}
		else
		{	tempPoint.x = ([[inKnots objectAtIndex: n] x] + [[x objectAtIndex:n-1] doubleValue])/2;
			tempPoint.y = ([[inKnots objectAtIndex: n] y] + [[y objectAtIndex:n-1] doubleValue])/2;
			[outSecondControlPoints replaceObjectAtIndex:i withObject:tempPoint];
		}		
			
		[tempPoint release];
	}	
	 
	[RHS release];
	[inKnots release];
    
	return YES;  
	
}





//This method is used by getFromKnots:outFirstControlPoints:andSecondControlPoints.

//It solves a tridiagonal system for one of coordinates (x or y)
// of first Bezier control points.

// accepts : Right hand side vector.
// returns: Solution vector.

+ (NSMutableArray *)getFirstControlPointsFromRHS:(NSMutableArray *)inRHS{
	
	[inRHS retain];
	int i;
	int n = [inRHS count];
	
	NSMutableArray *firstControlPoints = [[NSMutableArray alloc] init];//Solution Vector
	NSMutableArray *tmp = [[NSMutableArray alloc] init]; // temporary workATace.
	[self makeArrayElementsNilTill:n forArray: tmp];
	[self makeArrayElementsNilTill:n forArray:firstControlPoints ];
	double b = 2.0;
	
	double tempDouble = [[inRHS objectAtIndex:0] doubleValue]/b;
	[firstControlPoints replaceObjectAtIndex:0 withObject:[NSNumber numberWithDouble:tempDouble] ];
	
	for(i = 1;i<n;++i) // Decomposition and forward substitution.
	{
		
		tempDouble = 1/b;
		[tmp replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:tempDouble]];
		
		b = (i < n-1?4.0:3.5) - [[tmp objectAtIndex:i] doubleValue];
		
		tempDouble = ([[inRHS objectAtIndex:i] doubleValue] - [[firstControlPoints objectAtIndex:i-1] doubleValue])/b;
		
		[firstControlPoints replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:tempDouble] ];
		
		
	}
	
	for(i = 1;i<n;++i) //Back Substitution
	{
		tempDouble = [[tmp objectAtIndex:n-i] doubleValue]* [[firstControlPoints objectAtIndex:n-i] doubleValue];
		tempDouble = [[firstControlPoints objectAtIndex:n-i-1] doubleValue] - tempDouble ;
		[firstControlPoints replaceObjectAtIndex:n-i-1 withObject:[NSNumber numberWithDouble:tempDouble]];
		
	}
	
	[inRHS release];
	[tmp release];
	return [firstControlPoints autorelease];
}

//end 


@end
