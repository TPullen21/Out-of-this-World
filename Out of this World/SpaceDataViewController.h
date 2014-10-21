//
//  SpaceDataViewController.h
//  Out of this World
//
//  Created by Tom Pullen on 14/10/2014.
//
//

#import <UIKit/UIKit.h>
#import "SpaceObject.h"

@interface SpaceDataViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SpaceObject *spaceObject;

@end
