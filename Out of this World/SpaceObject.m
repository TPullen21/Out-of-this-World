//
//  SpaceObject.m
//  Out of this World
//
//  Created by Tom Pullen on 09/10/2014.
//
//

#import "SpaceObject.h"

@implementation SpaceObject

- (id)init {
    return [self initWithData:nil andImage:nil];
}

- (id)initWithData:(NSDictionary *)data andImage:(UIImage *)image {
    
    self = [super init];
    
    if (self != nil) {
        self.spaceImage = image;//data[PLANET_IMAGE];
        self.name = data[PLANET_NAME];
        self.nickName = data[PLANET_NICKNAME];
        self.interestingFact = data[PLANET_INTERESTING_FACT];
        self.gravitationalForce = [data[PLANET_GRAVITY] floatValue];
        self.diameter = [data[PLANET_DIAMETER] floatValue];
        self.yearLength = [data[PLANET_YEAR_LENGTH] floatValue];
        self.dayLength = [data[PLANET_DAY_LENGTH] floatValue];
        self.temperature = [data[PLANET_TEMPERATURE] floatValue];
        self.numberOfMoons = [data[PLANET_NUMBER_OF_MOONS] floatValue];
    }
    
    return self;
}

@end
