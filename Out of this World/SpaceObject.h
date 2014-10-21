//
//  SpaceObject.h
//  Out of this World
//
//  Created by Tom Pullen on 09/10/2014.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AstronomicalData.h"

@interface SpaceObject : NSObject

@property (nonatomic) float gravitationalForce;
@property (nonatomic) float diameter;
@property (nonatomic) float yearLength;
@property (nonatomic) float dayLength;
@property (nonatomic) float temperature;
@property (nonatomic) int numberOfMoons;
@property (strong, nonatomic) UIImage *spaceImage;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *interestingFact;

- (id)initWithData:(NSDictionary *)data andImage:(UIImage *)image;

@end
