
//  ATSmoothCurveAlgorithm.h


//  Created by Amogh Talpallikar



//All NSMutabelArrays containing CGPoints contain them in a wrapper of ATGraphPoint.
//and other NSMuatbelArrays containing doubles store Item as NSNumbers.
// This Algorithm is adopted from the C# version available on http://www.codeproject.com/Articles/31859/Draw-a-Smooth-Curve-through-a-Set-of-2D-Points-wit
/*
 To use this Algorithm, import this header file and ATGraphPoint.h in your source code file and then create three NSMutableArrays.
 First Array should hold ATGraphPoints wrappers on CGPoints containing all the points(called knots) through which graph should flow.
 Other arrays should be empty but must be instantiated.
 
 Use getFromKnots:FirstControlPoints:andSecondControlPoints: method to get the required control points.
 pass the first NSMutableArray as knots and pass the others in first and second control points.
 
 After this the control points arrays, will have respective control points for each consecutive knot point in them.
 Draw a Bezier curves between two consecutive points and take one control point from each array.
 As a result, you should get a smooth looking curve.
 */
#import <Foundation/Foundation.h>



@interface ATSmoothCurveAlgorithm : NSObject 

+ (void)makeArrayElementsNilTill:(int)n forArray:(NSMutableArray*)inArray;
+ (NSMutableArray *)getFirstControlPointsFromRHS:(NSMutableArray *)inRHS;
+ (BOOL)getFromKnots:(NSMutableArray*)inKnots
 FirstControlPoints:(NSMutableArray*)outFirstControlPoints
 andSecondControlPoints:(NSMutableArray*)outSecondControlPoints;

@end
